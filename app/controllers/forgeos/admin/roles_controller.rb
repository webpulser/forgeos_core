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
        wants.js
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
      columns = %w(forgeos_roles.name forgeos_roles.name count(forgeos_people.id) created_at active)
      per_page = params[:iDisplayLength] ? params[:iDisplayLength].to_i : 10
      offset = params[:iDisplayStart] ? params[:iDisplayStart].to_i : 0
      page = (offset / per_page) + 1
      order_column = params[:iSortCol_0].to_i
      order = "#{columns[order_column]} #{params[:sSortDir_0] ? params[:sSortDir_0].upcase : 'ASC'}"

      conditions = {}
      includes = []
      group_by = []
      options = { :page => page, :per_page => per_page }

      if params[:category_id]
        conditions[:forgeos_categories_elements] = { :category_id => params[:category_id] }
        includes << :categories
      end

      if order_column == 2
        includes << :administrators
        group_by << 'forgeos_roles.id'
      end

      options[:conditions] = conditions unless conditions.empty?
      options[:include] = includes unless includes.empty?
      options[:group] = group_by.join(', ') unless group_by.empty?
      options[:order] = order unless order.squeeze.blank?

      if params[:sSearch] && !params[:sSearch].blank?
        options[:star] = true
        if options[:order]
          options[:order].gsub!('forgeos_roles.', '')
        end
        @roles = Role.search(params[:sSearch],options)
      else
        @roles = Role.paginate(options)
      end
    end
  end
end
