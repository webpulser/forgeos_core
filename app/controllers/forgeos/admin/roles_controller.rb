module Forgeos
  class Admin::RolesController < Admin::BaseController
    before_filter :get_role, :only => [:show, :edit, :update, :destroy, :activate, :duplicate]
    before_filter :new_role, :only => [:new, :create]

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
    end

    def duplicate
      @role = @role.dup
      render :action => 'new'
    end

    def edit
    end

    def create
      if @role.save
        flash[:notice] = I18n.t('role.create.success').capitalize
        redirect_to [forgeos_core, :edit, :admin, @role]
      else
        flash[:error] = I18n.t('role.create.failed').capitalize
        render :action => "new"
      end
    end

    def update
      if @role.update_attributes(params[:role])
        flash[:notice] = I18n.t('role.update.success').capitalize
      else
        flash[:error] = I18n.t('role.update.failed').capitalize
      end
      render :action => "edit"
    end

    def destroy
      if @role.destroy
        flash[:notice] = I18n.t('role.destroy.success').capitalize
      else
        flash[:error] = I18n.t('role.destroy.failed').capitalize
      end
      respond_to do |wants|
        wants.html do
          redirect_to([forgeos_core,:admin,:roles])
        end
        wants.js { render :nothing => true }
      end
    end

    def activate
      @role.activate
      respond_to do |wants|
        wants.html do
          redirect_to([forgeos_core,:admin,:roles])
        end
        wants.js
      end
    end

  private

    def get_role
      unless @role = Role.find_by_id(params[:id])
        flash[:error] = I18n.t('role.not_exist').capitalize
        return redirect_to([forgeos_core,:admin,:roles])
      end
    end

    def new_role
      @role = Role.new(params[:role])
    end

    def sort
      items, search_query = forgeos_sort_from_datatables(Role, %w(name name administrators_id created_at active), %w(name))
      @roles = items.search(search_query).result
    end
  end
end
