module Forgeos
  class Admin::RolesController < Admin::BaseController
    helper_method :role

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
      role
    end

    def new
    end

    def duplicate
      @role = role.dup
      render :action => 'new'
    end

    def edit
      role
    end

    def create
      if role.save
        flash.notice = I18n.t('role.create.success').capitalize
        redirect_to [forgeos_core, :edit, :admin, role]
      else
        flash.alert = I18n.t('role.create.failed').capitalize
        render :action => "new"
      end
    end

    def update
      if role.save
        flash.notice = I18n.t('role.update.success').capitalize
      else
        flash.alert = I18n.t('role.update.failed').capitalize
      end
      render :action => "edit"
    end

    def destroy
      if role.destroy
        flash.notice = I18n.t('role.destroy.success').capitalize
      else
        flash.alert = I18n.t('role.destroy.failed').capitalize
      end
      respond_to do |wants|
        wants.html do
          redirect_to([forgeos_core,:admin,:roles])
        end
        wants.js { render :nothing => true }
      end
    end

    def activate
      role.activate
      respond_to do |wants|
        wants.html do
          redirect_to([forgeos_core,:admin,:roles])
        end
        wants.js
      end
    end

  private
    def role
      return @role if @role
      unless @role = (params[:id] ? Forgeos::Role.find_by_id(params[:id]) : Forgeos::Role.new)
        flash.alert = t('role.not_exist').capitalize
        return redirect_to([forgeos_core, :admin, :roles])
      end

      @role.attributes = params[:role] if params[:role]

      @role
    end

    def sort
      items, search_query = forgeos_sort_from_datatables(Role, %w(name name roles_id created_at active), %w(name))
      @roles = items.search(search_query).result
    end
  end
end
