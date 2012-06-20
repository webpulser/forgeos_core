module Forgeos
  class Admin::AttachmentsController < Admin::BaseController
    helper_method :attachment
    before_filter :get_file_type, :only => [:index, :manage]
    before_filter :get_thumbnails, :only => [:show, :edit, :update]
    skip_before_filter :verify_authenticity_token, :only => [:create]

    def manage
      @attachments = @attachment_class.where(:parent_id => nil).order('created_at DESC').page(params[:page]).per(10)
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

    # GET /attachments/1
    def show
      attachment
    end

    # GET /attachments/1/download
    def download
      send_file(attachment.full_filename)
    end

    # GET /attachments/1/edit
    def edit
      attachment
    end

    def update
      params[:attachment].delete(:filename) if params[:attachment] and params[:attachment].has_key?(:filename)
      if attachment.save
        flash.notice = I18n.t('attachment.update.success').capitalize
      else
        flash.alert = I18n.t('product.update.failed').capitalize
      end
      render :action => 'edit'
    end

    # POST /attachments
    def create
      saved = attachment.save
      respond_to do |format|
        format.json do
          if saved
            flash.notice = I18n.t('attachment.create.success').capitalize

            if params[:target].present? and type = params[:target].constantize and object = type.find_by_id(params[:target_id])
              object.attachments << attachment
            end

            if parent_category = AttachmentCategory.find_by_id(params[:parent_id])
              attachment.categories << parent_category
            end

            render :json => { :result => 'success', :id => attachment.id, :path => attachment.public_filename, :size => attachment.size, :type => attachment.class.model_name.singular_route_key }
          else
            render :json => { :result => 'error', :error => attachment.errors.first }
          end
        end

        format.js do
          render :text => "<html><body><script type='text/javascript' charset='utf-8'>var loc = document.location; with(window.parent) { setTimeout(function() { window.eval('upload_callback()'); if (typeof(loc) !== 'undefined') loc.replace('about:blank'); }, 1) };</script></body></html>".html_safe
        end
      end
    end

    # DELETE /attachments/1
    def destroy
      if attachment.destroy
        flash.notice = I18n.t('attachment.destroy.success').capitalize
      else
        flash.alert = I18n.t('attachment.destroy.failed').capitalize
      end
      respond_to do |wants|
        wants.html do
          redirect_to([forgeos_core, :admin, attachment.class.model_name.route_key])
        end
        wants.js { render :nothing => true }
      end
    end

    private

    def attachment
      return @attachment if @attachment
      unless @attachment = (params[:id] ? Forgeos::Attachment.find_by_id(params[:id]) : Forgeos::Attachment.new_from_rails_form(params))
        flash.alert = I18n.t('attachment.not_exist').capitalize
        return redirect_to([forgeos_core, :admin, :library])
      end
      @attachment.attributes = params[:attachment] if params[:attachment]
      @attachment_class = @attachment.class
      @file_type = @attachment_class.model_name.singular_route_key

      @attachment
    end

    def get_thumbnails
      @thumbnails = @attachment ? @attachment.thumbnails.all(:order => '(width*height) DESC') : []
    end

    def get_file_type
      begin
        @attachment_class = if params[:klass].present?
          params[:klass].camelize.constantize
        else
          Medium
        end

        @file_type = @attachment_class.model_name.singular_route_key
      rescue NameError => e
        flash.alert = e.message
        return redirect_to([forgeos_core, :admin, :library])
      end
    end

    def sort
      items, search_query = forgeos_sort_from_datatables(@attachment_class, %w(filename filename content_type updated_at size used), %w(filename content_type name))
      @attachments = items.where(:parent_id => nil).search(search_query).result
    end
  end
end
