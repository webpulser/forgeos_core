class Admin::AttachmentsController < Admin::BaseController
  before_filter :get_media, :only => [:show, :download, :edit, :update, :destroy]
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
    @thumbnails = @media.thumbnails.all :order => '(width*height) DESC'
  end

  # GET /medias/1
  def download
    send_file(@media.full_filename)
  end

  # GET /medias/1/edit
  def edit
    @thumbnails = @media.thumbnails.all :order => '(width*height) DESC'
  end
  
  def update
    %w(media picture pdf video doc).each do |key|
      params[:attachment] = params[key] if params[key]
    end
    if @media.update_attributes(params[:attachment])
      flash[:notice] = I18n.t('media.update.success').capitalize
      return redirect_to(admin_library_path)
    else
      flash[:error] = I18n.t('product.update.failed').capitalize
      render :action => 'edit'
    end
  end

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
          when 'video/x-msvideo', 'video/quicktime'
            @media = Video.new(params[:attachment])
          when 'application/msword', 'application/vnd.oasis.opendocument.text'
            @media = Doc.new(params[:attachment])
          else
            @media = Media.new(params[:attachment])
          end

          @media.uploaded_data = { 'tempfile' => params[:Filedata], 'content_type' => @content_type, 'filename' => params[:Filename]}
          
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

  # DELETE /medias/1
  def destroy
    if @media.destroy
      flash[:notice] = I18n.t('media.destroy.success').capitalize
    else
      flash[:notice] = I18n.t('media.destroy.failed').capitalize
    end
    return render :nothing => true if request.xhr?
    return redirect_to(admin_attachments_path)
  end

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
    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order = "#{columns[params[:iSortCol_0].to_i]} #{params[:iSortDir_0].upcase}"

    conditions = { :parent_id => nil }
    includes = []
    options = { :page => page, :per_page => per_page }
    
    # file type
    unless @file_type.nil?
      conditions[:type] = @file_type
      type = @file_type.camelize.constantize
    else
      type = Attachment
    end

    # category
    if params[:category_id]
      conditions[:categories_elements] = { :category_id => params[:category_id] }
      includes = :attachment_categories
    end

    options[:conditions] = conditions unless conditions.empty?
    options[:include] = includes unless includes.empty?
    options[:order] = order unless order.squeeze.blank?

    if params[:sSearch] && !params[:sSearch].blank?
      @medias = type.search(params[:sSearch],options)
    else
      @medias = type.paginate(:all,options)
    end
  end

end
