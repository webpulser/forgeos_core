class Admin::RolesController < Admin::BaseController
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
    @role = Role.find(params[:id])
  end

  def new
    @role = Role.new(params[:role])
  end

  def edit
    @role = Role.find(params[:id])
  end

  def create
    @role = Role.new(params[:role])
    if @role.save
      flash[:notice] = I18n.t('role.create.success').capitalize
      redirect_to(admin_role_path(@role))
    else
      render :action => "new"
    end
  end

  def update
    @role = Role.find(params[:id])

    if @role.update_attributes(params[:role])
      flash[:notice] = I18n.t('role.update.success').capitalize
      redirect_to(admin_role_path(@role))
    else
      render :action => "edit"
    end
  end

  def destroy
    @role = Role.find(params[:id])
    if @role.destroy
      flash[:notice] = I18n.t('role.destroy.success').capitalize
    else
      flash[:error] = I18n.t('role.destroy.failed').capitalize
    end
    redirect_to(admin_roles_path)
  end

  def rights
    @role = Role.find(params[:id])
  end

  def add_right
    @role = Role.find(params[:id])
    @role.update_attributes(params[:role])
    @role.save
    redirect_to :action => 'rights', :id => @role
  end

private

  def sort
    columns = %w(name)
    conditions = []
    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order = "#{columns[params[:iSortCol_0].to_i]} #{params[:iSortDir_0].upcase}"
    if params[:sSearch] && !params[:sSearch].blank?
      @roles = Role.search(params[:sSearch],
        :order => order,
        :page => page,
        :per_page => per_page)
    else
      @roles = Role.paginate(:all,
        :conditions => conditions,
        :order => order,
        :page => page,
        :per_page => per_page)
    end
  end
end
