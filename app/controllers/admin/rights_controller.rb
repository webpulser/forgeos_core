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
      return request.xhr? ? (render :nothing => true) : redirect_to([forgeos_core, :admin, @right])
    else
      flash[:error] = I18n.t('right.create.failed').capitalize
      if request.xhr?
        render :nothing => true, :json => { :result => 'error' }
        return false
      else
        render :action => 'new'
      end
    end
  end

  def update
    if @right.update_attributes(params[:right])
      flash[:notice] = I18n.t('right.update.success').capitalize
      return request.xhr? ? (render :nothing => true) : redirect_to([forgeos_core, :admin, @right])
    else
      flash[:error] = I18n.t('right.update.failed').capitalize
      if request.xhr?
        render :nothing => true, :json => { :result => 'error' }
        return false
      else
        render :action => 'edit'
      end
    end
  end

  def destroy
    if @right.destroy
      flash[:notice] = I18n.t('right.destroy.success').capitalize
      return request.xhr? ? (render :nothing => true) : redirect_to([forgeos_core, :admin, :rights])
    else
      flash[:error] = I18n.t('right.destroy.failed').capitalize
      if request.xhr?
        render :nothing => true, :json => { :result => 'error' }
        return false
      else
        redirect_to([forgeos_core, :admin, :rights])
      end
    end
  end

private

  def get_right
    unless @right = Right.find_by_id(params[:id])
      flash[:error] = I18n.t('right.not_exist').capitalize
      return redirect_to([forgeos_core, :admin, :rights])
    end
  end

  def sort
    columns = %w(rights.id rights.name controller_name action_name)
    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order = "#{columns[params[:iSortCol_0].to_i]} #{params[:sSortDir_0].upcase}"

    conditions = {}
    includes = []
    options = { :page => page, :per_page => per_page }

    if params[:category_id]
      conditions[:categories_elements] = { :category_id =>  params[:category_id] }
      includes << :right_categories
    end

    options[:conditions] = conditions unless conditions.empty?
    options[:include] = includes unless includes.empty?
    options[:order] = order unless order.squeeze.blank?

    if params[:sSearch] && !params[:sSearch].blank?
      options[:star] = true
      @rights = Right.search(params[:sSearch],options)
    else
      @rights = Right.paginate(:all,options)
    end
  end
end
