module Forgeos
  class Admin::AdministratorsController < Admin::BaseController
    expose(:administrator, :model => Forgeos::Administrator)

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
      administrator
    end

    def new
      administrator
    end

    def edit
      administrator
    end

    def create
      if administrator.save
        flash.notice = t('administrator.create.success').capitalize
        redirect_to [forgeos_core, :admin, administrator]
      else
        flash.alert = t('administrator.create.failed').capitalize
        render :action => "new"
      end
    end

    def update
      if administrator.save
        flash.notice = t('administrator.update.success').capitalize
        redirect_to [forgeos_core, :admin, administrator]
      else
        flash.alert = t('administrator.update.failed').capitalize
        render :action => "edit"
      end
    end

    def destroy
      if administrator.destroy
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
      unless administrator.active?
        if administrator.activate
          flash.notice = I18n.t('administrator.activation.success').capitalize
        else
          flash.alert = I18n.t('administrator.activation.failed').capitalize
        end
      else
        if administrator.disactivate
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

    def sort
      items, search_query = forgeos_sort_from_datatables(Administrator, %w(id full_name role_name email active), %w(firstname lastname role_name email))
      @administrators = items.search(search_query).result
    end
  end
end

