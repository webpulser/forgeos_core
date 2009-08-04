class Admin::MediasController < Admin::BaseController
  session :cookie_only => false, :only => :create
  before_filter :get_media, :only => [:show, :download, :destroy]

  def index
    if params[:file_type]
      @medias = Attachment.find_all_by_parent_id_and_type(nil,params[:file_type].capitalize)
    else
      @medias = Attachment.find_all_by_parent_id(nil)
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
          return redirect_to(admin_medias_path)
        end

        attachable_type.constantize
      rescue NameError
        flash[:error] = I18n.t('media.attach.failed').capitalize
        return redirect_to(admin_medias_path)
      end
    end

    render :action => 'create'
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
              sortable_attachment = @media.sortable_attachments.new

              # get attachable model
              begin
                # check if model is an available attachable type
                attachable_type = params[:target].camelize
                unless Forgeos::AttachableTypes.include?(attachable_type)
                  return render :json => { :result => 'error', :error => I18n.t('media.attach.unknown_type').capitalize }
                end

                target = attachable_type.constantize
              rescue NameError
                return render :json => { :result => 'error', :error => I18n.t('media.attach.failed').capitalize }
              end

              sortable_attachment.attachable = target.find_by_id(params[:target_id])
              sortable_attachment.save
            end
            render :json => { :result => 'success', :asset => @media.id}
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
#     return redirect_to(admin_medias_path)
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
    return redirect_to(admin_medias_path)
  end

private

  def get_media
    @media = Attachment.find_by_id params[:id]
    unless @media
      flash[:error] = I18n.t('media.not_exist').capitalize 
      return redirect_to(admin_medias_path)
    end
  end
end
