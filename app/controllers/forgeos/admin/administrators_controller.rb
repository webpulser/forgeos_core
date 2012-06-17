module Forgeos
  class Admin::AdministratorsController < Admin::BaseController
    before_filter :get_admin, :only => [:show, :edit, :update, :destroy, :activate]

    def index
      respond_to do |format|
        format.html # index.html.erb
        format.json do
          sort
          render :layout => false
        end
      end
    end

    def show
    end

    def new
      @admin = Administrator.new(params[:administrator])
    end

    def edit
    end

    def create
      @admin = Administrator.new(params[:administrator])
      if @admin.save
        flash.notice = t('administrator.create.success').capitalize
        redirect_to [forgeos_core, :edit, :admin, @admin]
      else
        flash.alert = t('administrator.create.failed').capitalize
        render :action => "new"
      end
    end

    def update
      if @admin.update_attributes(params[:administrator])
        flash.notice = t('administrator.update.success').capitalize
      else
        flash.alert = t('administrator.update.failed').capitalize
      end
      render :action => "edit"
    end

    def destroy
      if @admin.destroy
        flash.notice = t('administrator.destroy.success').capitalize
      else
        flash.alert = t('administrator.destroy.failed').capitalize
      end
      respond_to do |wants|
        wants.html do
          redirect_to([forgeos_core, :admin, :administrators])
        end
        wants.js { render :nothing => true }
      end
    end

    def activate
      unless @admin.active?
        if @admin.activate
          flash.notice = I18n.t('administrator.activation.success').capitalize
        else
          flash.alert = I18n.t('administrator.activation.failed').capitalize
        end
      else
        if @admin.disactivate
          flash.notice = I18n.t('administrator.disactivation.success').capitalize
        else
          flash.alert = I18n.t('administrator.disactivation.failed').capitalize
        end
      end
      respond_to do |wants|
        wants.html do
          redirect_to(:back)
        end
        wants.js
      end
    end

  private

    def get_admin
      unless @admin = Administrator.find_by_id(params[:id])
        flash.alert = t('administrator.not_exist').capitalize
        return redirect_to([forgeos_core, :admin, :administrators])
      end
    end

    def sort
      items, search_query = forgeos_sort_from_datatables(Administrator, %w(id full_name role_name email active), %w(firstname lastname role_name email))
      @admins = items.search(search_query).result
    end
  end
end
