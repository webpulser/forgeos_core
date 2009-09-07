class Admin::AttachmentsController < Admin::BaseController
  before_filter :get_media, :only => [:show, :download, :destroy]
  before_filter :get_categories, :only => [:index]

  def index
    respond_to do |format|
      format.html
      format.json do
        sort
        render :layout => false
      end
    end
  end

  # GET /medias/1
  def show
  end

  # GET /medias/1
  def download
    send_file(@media.full_filename)
  end

  # GET /medias/new
  def new
    @media = Attachment.new

    if params[:target] && params[:target_id] && !params[:target].blank?
      # get attachable model...
      begin
        # and check if model is an available attachable type
        attachable_type = params[:target].camelize

        unless Forgeos::AttachableTypes.include?(attachable_type)
          flash[:error] = I18n.t('media.attach.unknown_type').capitalize
          return redirect_to(admin_attachments_path)
        end

        attachable_type.constantize
      rescue NameError
        flash[:error] = I18n.t('media.attach.failed').capitalize
        return redirect_to(admin_attachments_path)
      end
    end
  end

#   # GET /medias/1/edit
#   def edit
#     @media = Attachment.find(params[:id])
#   end

  # POST /medias
  def create
    
    respond_to do |format|
      format.json do
        if params[:Filedata]
          require 'mime/types'
          @content_type = MIME::Types.type_for(params[:Filename]).first.to_s
          case @content_type
          when 'image/png','image/jpeg','image/pjpeg', 'image/gif'
            @media = Picture.new(params[:attachment])
          when 'application/pdf'
            @media = Pdf.new(params[:attachment])
          when 'video/x-msvideo'
            @media = Video.new(params[:attachment])
          when 'application/msword', 'application/vnd.oasis.opendocument.text'
            @media = Doc.new(params[:attachment])
          else
            @media = Media.new(params[:attachment])
          end

          @media.uploaded_data = { 'tempfile' => params[:Filedata], 'content_type' => 'none', 'filename' => params[:Filename] }
          @media.content_type = @content_type
          
          if @media.save
            flash[:notice] = I18n.t('media.create.success').capitalize

            if params[:target] && params[:target_id] && !params[:target].blank?
              
              begin
                target = params[:target].camelize
                # check if model is an available type
                unless Forgeos::AttachableTypes.include?(target)
                  return render :json => { :result => 'error', :error => I18n.t('media.attach.unknown_type').capitalize }
                end
              rescue NameError
                return render :json => { :result => 'error', :error => I18n.t('media.attach.failed').capitalize }
              end

              type = target.constantize
              object = type.find_by_id(params[:target_id])
              attachments = (object.attachment_ids << @media.id)
              object.update_attribute('attachment_ids', attachments)
              
            end
            render :json => { :result => 'success', :id => @media.id, :path => @media.public_filename(''), :size => @media.size, :type => @media.type.to_s.upcase }
          else
            render :json => { :result => 'error', :error => @media.errors.first }
          end
        else
          render :json => { :result => 'error', :error => 'bad parameters' }
        end
      end
    end

  end

#   # PUT /medias/1
#   def update
#     @users = User.all
    
#     if @media.update_attributes(params[:attachment])
#       flash[:notice] = I18n.t('media.update.success').capitalize
#     else
#       flash[:error] = I18n.t('media.update.failed').capitalize
#     end
#     return redirect_to(admin_attachments_path)
#   end

  # DELETE /medias/1
  def destroy
    if @media && @media.destroy
      flash[:notice] = I18n.t('media.destroy.success').capitalize
    else
      flash[:notice] = I18n.t('media.destroy.failed').capitalize
    end

    # media destroy is requested from another controller
    if request.xhr? && params[:target] && params[:target_id] && !params[:target].blank?
      # get the attached model and retrieve all attachments
      begin
        target = params[:target].camelize.constantize
        attachable = target.find_by_id(params[:target_id])
        @medias = attachable.attachments if attachable
      rescue NameError
        index
      end

      return render(:update) do |page|
        # without dataTables
        # page << "$('#media_#{params[:id]}').parents('tr').remove()"
        # with dataTables
        page << "oTable.fnDeleteRow(oTable.fnGetPosition($('#media_#{params[:id]}').parents('tr')[0]));"
        page << display_standard_flashes('', false)
      end
    end
    return redirect_to(admin_attachments_path)
  end

  # Sort media for attachable
#  def sort
#    if params['media_list']
#      # get attachable model...
#      begin
#        # and check if model is an available attachable type
#        attachable_type = params[:target].camelize
#
#        unless Forgeos::AttachableTypes.include?(attachable_type)
#          flash[:error] = I18n.t('media.attach.unknown_type').capitalize
#          return redirect_to(admin_attachments_path)
#        end
#
#        target = attachable_type.constantize
#      rescue NameError
#        flash[:error] = I18n.t('media.attach.failed').capitalize
#        return redirect_to(admin_attachments_path)
#      end
#
#      # update position of attachments
#      if @target = target.find_by_id(params[:id])
#        medias = @target.sortable_attachments
#        medias.each do |media|
#          if index = params['media_list'].index(media.attachment_id.to_s)
#            media.update_attribute(:position, index+1)
#          end
#        end
#
#        # refresh list of medias
#        return render(:update) do |page|
#          page.replace_html("list_medias", :partial => 'admin/medias/list', :locals => { :medias => @target.attachments, :target => params[:target], :target_id => params[:id], :remote => true})
#        end
#      end
#    end
#    render(:nothing => true)
#  end

private

  def get_media
    @media = Attachment.find_by_id params[:id]
    unless @media
      flash[:error] = I18n.t('media.not_exist').capitalize 
      return redirect_to(admin_attachments_path)
    end
  end

  def get_categories
    @file_type = params[:file_type]
    unless @file_type.nil?
      type = "#{@file_type}_category".camelize.constantize
    else
      type = AttachmentCategory
    end
    @categories = type.find_all_by_parent_id(nil)
  end

  def sort
    columns = %w(filename filename content_type updated_at size used '')
    conditions =[[]]
    conditions[0] << 'attachments.parent_id IS NULL'
    
    # file type
    unless @file_type.nil?
      conditions[0] << 'attachments.type = ?'
      conditions << @file_type
      type = @file_type.camelize.constantize
    else
      type = Attachment
    end

    # category
    if params[:category_id]
      conditions[0] << 'attachment_categories_attachments.attachment_category_id = ?'
      conditions << params[:category_id]
    end

    conditions[0] = conditions[0].join(' AND ')

    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order = "#{columns[params[:iSortCol_0].to_i]} #{params[:iSortDir_0].upcase}"
    if params[:sSearch] && !params[:sSearch].blank?
      @medias = type.search(params[:sSearch],
        :conditions => conditions,
        :include => ['attachment_categories'],
        :order => order,
        :page => page,
        :per_page => per_page)
    else
      @medias = type.paginate(:all,
        :conditions => conditions,
        :include => ['attachment_categories'],
        :order => order,
        :page => page,
        :per_page => per_page)
    end
  end

end
