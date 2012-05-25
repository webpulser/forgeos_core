module Forgeos
  class Admin::AttachmentsController < Admin::BaseController
    before_filter :get_media, :only => [:show, :download, :edit, :update, :destroy]
    before_filter :get_categories, :only => [:index]
    before_filter :get_thumbnails, :only => [:show, :edit, :update]
    skip_before_filter :verify_authenticity_token, :only => [:create]

    def manage
      @attachments = "#{params[:file_type]}".classify.constantize.paginate :page => params[:page], :order => 'created_at DESC', :per_page => 10, :conditions => { :parent_id => nil}
      render :partial => 'tiny_mce_list'
    end

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

    # GET /medias/1/edit
    def edit
    end

    def update
      file_type = nil
      %w(media picture pdf audio video doc).each do |key|
        if params[key]
          params[:attachment] = params[key]
          file_type = key
        end
      end
      params[:attachment][:filename] = @media.filename
      rack_file = params[:attachment][:uploaded_data]
      if !(rack_file.respond_to?(:file_type) && !@media.class.attachment_options[:content_type].include?(rack_file.file_type)) &&
        @media.update_attributes(params[:attachment])
        flash[:notice] = I18n.t('media.update.success').capitalize
      else
        flash[:error] = I18n.t('product.update.failed').capitalize
        edit
      end
      render :action => 'edit'
    end

    # POST /medias
    def create
      respond_to do |format|
        format.json do
          if params[:Filedata]
            @media = Attachment.new_from_rails_form(params)
            if @media.save
              flash[:notice] = I18n.t('media.create.success').capitalize

              if params[:target] && params[:target_id] && !params[:target].blank?
                type = target.constantize
                object = type.find_by_id(params[:target_id])
                attachments = (object.attachment_ids << @media.id)
                object.update_attribute('attachment_ids', attachments)
              end

              if params[:parent_id]
                if parent_category = Category.find_by_id(params[:parent_id])
                  @media.categories << parent_category
                end
              end

              render :json => { :result => 'success', :id => @media.id, :path => @media.public_filename(''), :size => @media.size, :type => @media.type.to_s.upcase }
            else
              render :json => { :result => 'error', :error => @media.errors.first }
            end
          else
            render :json => { :result => 'error', :error => 'bad parameters' }
          end
        end

        format.js do
          if params[:Filedata]
            @media = Attachment.new_from_rails_form(params)
            @media.save
          end

          responds_to_parent do
            render(:update) do |page|
              page << "upload_callback();"
            end
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
      respond_to do |wants|
        wants.html do
          redirect_to([forgeos_core, :admin, @media.class.to_s.underscore.pluralize])
        end
        wants.js
      end
    end

    private

    def get_media
      @media = Attachment.find_by_id params[:id]
      unless @media
        flash[:error] = I18n.t('media.not_exist').capitalize
        return redirect_to([forgeos_core, :admin, :library])
      end
    end

    def get_thumbnails
      @thumbnails = @media ? @media.thumbnails.all(:order => '(width*height) DESC') : []
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
      # file type
      @type = if @file_type.present?
        @file_type.camelize.constantize
      else
        Attachment
      end

      items, search_query = forgeos_sort_from_datatables(type, %w(filename filename content_type updated_at size used), %w(filename content_type name))
      @medias = items.where(:parent_id => nil).search(search_query).result
    end
  end
end
