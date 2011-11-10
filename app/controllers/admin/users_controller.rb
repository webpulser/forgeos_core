class Admin::UsersController < Admin::BaseController
  before_filter :get_user, :only => [:show, :activate, :edit, :update, :destroy]
  before_filter :new_user, :only => [:new, :create]

  def index
    respond_to do |format|
      format.html
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

  def create
    if @user.save
      flash[:notice] = I18n.t('user.create.success').capitalize
      redirect_to([forgeos_core, :edit, :admin, @user])
    else
      flash[:error] = I18n.t('user.create.failed').capitalize
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = I18n.t('user.update.success').capitalize
    else
      flash[:error] = I18n.t('user.update.failed').capitalize
    end
    render :action => 'edit'
  end

  # Remotly Destroy an User
  # return the list of all users
  def destroy
    if @user.destroy
      flash[:notice] = I18n.t('user.destroy.success').capitalize
    else
      flash[:error] = I18n.t('user.destroy.failed').capitalize
    end
    respond_to do |wants|
      wants.html do
        redirect_to([forgeos_core, :admin, :users])
      end
      wants.js
    end
  end

  def activate
    unless @user.active?
      if @user.activate
        flash[:notice] = I18n.t('user.activation.success').capitalize
      else
        flash[:error] = I18n.t('user.activation.failed').capitalize
      end
    else
      if @user.disactivate
        flash[:notice] = I18n.t('user.disactivation.success').capitalize
      else
        flash[:error] = I18n.t('user.disactivation.failed').capitalize
      end
    end
    respond_to do |wants|
      wants.html do
        redirect_to(:back)
      end
      wants.js
    end
  end

  # example action to return the contents
  # of a table in CSV format
  def export_newsletter
    @users = User.all(:select => 'firstname, lastname, email')
    return flash[:error] = I18n.t('user.export.failed').capitalize if @users.empty?
    stream_csv do |csv|
      csv << %w(firstname lastname email)
      @users.each do |u|
        csv << [u.firstname, u.lastname, u.email]
      end
    end
  end
private

  def get_user
    unless @user = User.find_by_id(params[:id])
      flash[:error] = I18n.t('user.not_exist').capitalize
      return redirect_to([forgeos_core, :admin, :users])
    end
  end

  def new_user
    @user = User.new(params[:user])
  end

  def stream_csv
    filename = params[:action] + ".csv"

    #this is required if you want this to work with IE
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = 'text/plain'
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
      headers['Expires'] = "0"
    else
      headers['Content-Type'] ||= 'text/csv'
    end
    headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""

    output = ''
    yield(CsvParser.new(output, :row_sep => "\r\n"))
    render :text => output, :stream => true
  end

  def sort
    columns = %w(id full_name email active)

    per_page = params[:iDisplayLength] ? params[:iDisplayLength].to_i : 10
    offset = params[:iDisplayStart] ? params[:iDisplayStart].to_i : 0
    page = (offset / per_page) + 1
    order = "#{columns[params[:iSortCol_0].to_i]} #{params[:sSortDir_0] ? params[:sSortDir_0].upcase : 'ASC'}"

    conditions = {}
    includes = []
    options = { :order => order, :page => page, :per_page => per_page }

    if params[:category_id]
      conditions[:categories_elements] = { :category_id => params[:category_id] }
      includes << :categories
    end

    if params[:ids]
      conditions[:people] = { :id => params[:ids] }
    end

    options[:conditions] = conditions unless conditions.empty?
    options[:include] = includes unless includes.empty?

    if params[:sSearch] && !params[:sSearch].blank?
      options[:star] = true
      @users = User.search(params[:sSearch],options)
    else
      options[:select] = "*, #{User.sql_fullname_query} as full_name"
      @users = User.paginate(options)
    end
  end
end
