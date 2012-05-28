module Forgeos
  class Admin::AttachmentsController < Admin::BaseController
    before_filter :get_media, :only => [:show, :download, :edit, :update, :destroy]
    before_filter :get_file_type, :only => [:index, :manage]
    before_filter :get_thumbnails, :only => [:show, :edit, :update]
    skip_before_filter :verify_authenticity_token, :only => [:create]

    def manage
      @attachments = @media_class.where(:parent_id => nil).order('created_at DESC').page(params[:page]).per(10)
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

    # GET /medias/1/download
    def download
      send_file(@media.full_filename)
    end

    # GET /medias/1/edit
    def edit
    end

    def update
      if params[:attachment] and
        params[:attachment][:filename] = @media.filename and
        @media.update_attributes(params[:attachment])

        flash[:notice] = I18n.t('media.update.success').capitalize
      else
        flash[:error] = I18n.t('product.update.failed').capitalize
      end
      render :action => 'edit'
    end

    # POST /medias
    def create
      @media = Attachment.new_from_rails_form(params)
      saved = @media.save
      respond_to do |format|
        format.json do
          if saved
            flash[:notice] = I18n.t('media.create.success').capitalize

            if params[:target].present? and type = params[:target].constantize and object = type.find_by_id(params[:target_id])
              object.attachments << @media
            end

            if parent_category = Category.find_by_id(params[:parent_id])
              @media.categories << parent_category
            end

            render :json => { :result => 'success', :id => @media.id, :path => @media.public_filename, :size => @media.size, :type => @media.class.model_name.singular_route_key }
          else
            render :json => { :result => 'error', :error => @media.errors.first }
          end
        end

        format.js do
          render :text => "<html><body><script type='text/javascript' charset='utf-8'>var loc = document.location; with(window.parent) { setTimeout(function() { window.eval('upload_callback()'); if (typeof(loc) !== 'undefined') loc.replace('about:blank'); }, 1) };</script></body></html>".html_safe
        end
      end
    end

    # DELETE /medias/1
    def destroy
      if @media.destroy
        flash[:notice] = I18n.t('media.destroy.success').capitalize
      else
        flash[:error] = I18n.t('media.destroy.failed').capitalize
      end
      respond_to do |wants|
        wants.html do
          redirect_to([forgeos_core, :admin, @media.class.model_name.route_key])
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
      @media_class = @media.class
      @file_type = @media_class.model_name.singular_route_key
    end

    def get_thumbnails
      @thumbnails = @media ? @media.thumbnails.all(:order => '(width*height) DESC') : []
    end

    def get_file_type
      begin
        @media_class = if params[:klass].present?
          params[:klass].camelize.constantize
        else
          Media
        end

        @file_type = @media_class.model_name.singular_route_key
      rescue NameError => e
        flash[:error] = e.message
        return redirect_to([forgeos_core, :admin, :library])
      end
    end

    def sort
      items, search_query = forgeos_sort_from_datatables(@media_class, %w(filename filename content_type updated_at size used), %w(filename content_type name))
      @medias = items.where(:parent_id => nil).search(search_query).result
    end
  end
end
