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
      flash[:notice] = t('administrator.create.success').capitalize
      redirect_to [forgeos_core, :edit, :admin, @admin]
    else
      flash[:error] = t('administrator.create.failed').capitalize
      render :action => "new"
    end
  end

  def update
    if @admin.update_attributes(params[:administrator])
      flash[:notice] = t('administrator.update.success').capitalize
    else
      flash[:error] = t('administrator.update.failed').capitalize
    end
    render :action => "edit"
  end

  def destroy
    if @admin.destroy
      flash[:notice] = t('administrator.destroy.success').capitalize
    else
      flash[:error] = t('administrator.destroy.failed').capitalize
    end
    respond_to do |wants|
      wants.html do
        redirect_to([forgeos_core, :admin, :administrators])
      end
      wants.js
    end
  end

  def activate
    if @admin.active?
      @admin.disactivate
    else
      @admin.activate
    end
  end
private

  def get_admin
    unless @admin = Administrator.find_by_id(params[:id])
      flash[:error] = t('administrator.not_exist').capitalize
      return redirect_to([forgeos_core, :admin, :administrators])
    end
  end

  def sort
    columns = %w(id full_name role_name email active)
    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order_column = params[:iSortCol_0].to_i
    order = "#{columns[order_column]} #{params[:sSortDir_0].upcase}"

    conditions = {}
    includes = []
    options = { :page => page, :per_page => per_page }

    if params[:category_id]
      conditions[:categories_elements] = { :category_id => params[:category_id] }
      includes << :categories
    end

    includes << :role if order_column == 2

    options[:conditions] = conditions unless conditions.empty?
    options[:include] = includes unless includes.empty?
    options[:order] = order unless order.squeeze.blank?

    if params[:sSearch] && !params[:sSearch].blank?
      options[:star] = true
      @admins = Administrator.search(params[:sSearch],options)
    else
      options[:select] = '*, CONCAT(lastname,firstname) as full_name, roles.name as role_name'
      @admins = Administrator.paginate(options)
    end
  end
end
