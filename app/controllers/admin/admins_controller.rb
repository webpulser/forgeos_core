class Admin::AdminsController < Admin::BaseController
  before_filter :get_admin, :only => [:show, :edit, :update, :destroy, :update_rights]

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
    @admin = Admin.new(params[:admin])
  end

  def edit
  end

  def create
    @admin = Admin.new(params[:admin])
    @admin.build_avatar(params[:avatar]) unless @admin.avatar

    if @admin.save
      flash[:notice] = I18n.t('admin.create.success').capitalize
      redirect_to(admin_admins_path)
    else
      flash[:error] = I18n.t('admin.create.failed').capitalize
      render :action => "new"
    end
  end

  def update
    if @admin.update_attributes(params[:admin])
      flash[:notice] = I18n.t('admin.update.success').capitalize
      redirect_to(admin_admins_path)
    else
      flash[:error] = I18n.t('admin.update.failed').capitalize
      render :action => "edit"
    end
  end

  def destroy
    if request.delete? && @admin.destroy
      flash[:notice] = I18n.t('admin.destroy.success').capitalize
    else
      flash[:error] = I18n.t('admin.destroy.failed').capitalize
    end
    redirect_to(admin_admins_path)
  end
private

  def get_admin
    unless @admin = Admin.find_by_id(params[:id])
      flash[:error] = I18n.t('admin.not_exist').capitalize
      return redirect_to(admin_admins_path)
    end
  end

  def sort
    columns = %w(lastname roles.name email created_at)
    conditions = []
    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order = "#{columns[params[:iSortCol_0].to_i]} #{params[:iSortDir_0].upcase}"

    if params[:sSearch] && !params[:sSearch].blank?
      @admins = Admin.search(params[:sSearch],
        :include => 'role',
        :order => order,
        :page => page,
        :per_page => per_page)
    else
      @admins = Admin.paginate(:all,
        :conditions => conditions,
        :include => 'role',
        :order => order,
        :page => page,
        :per_page => per_page)
    end
  end
end
