class Admin::RolesController < Admin::BaseController
  before_filter :get_role, :only => [:show, :edit, :update, :destroy, :rights, :add_right, :activate, :duplicate]
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
    @role = @role.clone
    render :action => 'new'
  end

  def edit
  end

  def create
    if @role.save
      flash[:notice] = I18n.t('role.create.success').capitalize
      return redirect_to([:admin, @role])
    else
      flash[:error] = I18n.t('role.create.failed').capitalize
      render :action => "new"
    end
  end

  def update
    if @role.update_attributes(params[:role])
      flash[:notice] = I18n.t('role.update.success').capitalize
      return redirect_to([:admin, @role])
    else
      flash[:error] = I18n.t('role.update.failed').capitalize
      render :action => "edit"
    end
  end

  def destroy
    if @role.destroy
      flash[:notice] = I18n.t('role.destroy.success').capitalize
    else
      flash[:error] = I18n.t('role.destroy.failed').capitalize
    end
    return redirect_to(admin_roles_path)
  end

  def rights
  end

  def add_right
    @role.update_attributes(params[:role])
    @role.save
    return redirect_to([:admin, @role])
  end

  def activate
    render :text => @role.activate
  end

private

  def get_role
    unless @role = Role.find_by_id(params[:id])
      flash[:error] = I18n.t('role.not_exist').capitalize
      return redirect_to(admin_roles_path)
    end
  end

  def new_role
    @role = Role.new(params[:role])
  end

  def sort
    columns = %w(name name count(people.id) created_at '' '')
    conditions = {}

    if params[:category_id]
      conditions[:role_categories_products] = { :role_category_id => params[:category_id] }
    end

    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order = "#{columns[params[:iSortCol_0].to_i]} #{params[:iSortDir_0].upcase}"
    if params[:sSearch] && !params[:sSearch].blank?
      @roles = Role.search(params[:sSearch],
        :include => [ :admins, :role_categories],
        :group => 'roles.id',
        :order => order,
        :page => page,
        :per_page => per_page)
    else
      @roles = Role.paginate(:all,
        :conditions => conditions,
        :include => [ :admins, :role_categories],
        :group => 'roles.id',
        :order => order,
        :page => page,
        :per_page => per_page)
    end
  end
end
