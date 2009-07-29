class Admin::MediasController < Admin::BaseController
  session :cookie_only => false, :only => :create

  def index
    if params[:file_type]
      @medias = Attachment.find_all_by_parent_id_and_type(nil,params[:file_type].capitalize)
    else
      @medias = Attachment.find_all_by_parent_id(nil)
    end
  end

  # GET /medias/1
  def show
    @media = Attachment.find(params[:id])
    send_file(@media.full_filename)
  end

  # GET /medias/new
  def new
    @media = Attachment.new
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
            render :json => { :result => 'success', :asset => @media.id}
          else
            logger.debug(@media.errors.inspect)
            render :json => { :result => 'error', :error => @media.errors.first }
          end
        else
          render :json => { :result => 'error', :error => 'bad parameters' }
        end
      end
    end

  end

  # PUT /medias/1
  def update
    @media = Attachment.find(params[:id])
    @users = User.all
    
    if @media.update_attributes(params[:attachment])
      flash[:notice] = I18n.t('media.update.success').capitalize
    else
      flash[:error] = I18n.t('media.update.failed').capitalize
    end
    return redirect_to(admin_medias_path)
  end

  # DELETE /medias/1
  def destroy
    @media = Attachment.find(params[:id])
    if @media && @media.destroy
      flash[:notice] = I18n.t('media.destroy.success').capitalize
    else
      flash[:notice] = I18n.t('media.destroy.failed').capitalize
    end

    respond_to do |format|
      format.html { redirect_to(admin_medias_path) }
      format.xml  { head :ok }
    end
  end
end
