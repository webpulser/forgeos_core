module Forgeos
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
      @users = User.select('firstname, lastname, email').all
      return flash[:error] = I18n.t('user.export.failed').capitalize if @users.empty?
      csv_string = CsvParser.generate do |csv|
        csv << %w(firstname lastname email)
        @users.each do |u|
          csv << [u.firstname, u.lastname, u.email]
        end
      end

      send_data csv_string,
        :type => 'text/plain',
        :filename => 'export_newsletter.csv',
        :disposition => 'attachment'
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
        conditions[:forgeos_categories_elements] = { :category_id => params[:category_id] }
        includes << :categories
      end

      if params[:ids]
        conditions[:id] = params[:ids]
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
end
