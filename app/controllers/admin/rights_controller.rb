class Admin::RightsController < Admin::BaseController
  before_filter :get_right, :only => [:show, :edit, :update, :destroy]

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
    @right = Right.new(params[:right])
  end

  def edit
  end

  def create
    @right = Right.new(params[:right])
    if @right.save
      flash[:notice] = I18n.t('right.create.success').capitalize
      redirect_to(admin_right_path(@right))
    else
      flash[:error] = I18n.t('right.create.failed').capitalize
      render :action => "new"
    end
  end

  def update
    if @right.update_attributes(params[:right])
      flash[:notice] = I18n.t('right.update.success').capitalize
      redirect_to(admin_right_path(@right))
    else
      flash[:error] = I18n.t('right.update.failed').capitalize
      render :action => "edit"
    end
  end

  def destroy
    if @right.destroy
      flash[:notice] = I18n.t('right.destroy.success').capitalize
    else
      flash[:error] = I18n.t('right.destroy.failed').capitalize
    end
    redirect_to(admin_rights_url)
  end

private

  def get_right
    unless @right = Right.find_by_id(params[:id])
      flash[:error] = I18n.t('right.not_exist').capitalize
      return redirect_to(admin_rights_path)
    end
  end

  def sort
    columns = %w(name name '' controller_name action_name '')
    conditions = []
    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order = "#{columns[params[:iSortCol_0].to_i]} #{params[:iSortDir_0].upcase}"
    if params[:sSearch] && !params[:sSearch].blank?
      @rights = Right.search(params[:sSearch],
        :order => order,
        :page => page,
        :per_page => per_page)
    else
      @rights = Right.paginate(:all,
        :conditions => conditions,
        :order => order,
        :page => page,
        :per_page => per_page)
    end
  end
end
