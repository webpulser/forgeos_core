module Forgeos
  class Admin::UsersController < Admin::BaseController
    before_filter :get_user, :only => [:show, :activate, :edit, :update, :destroy, :assume]
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
        wants.js { render :nothing => true }
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

    def assume
      if assumed_user_session = assume_user(@user)
        redirect_to '/'
      else
        redirect_to [forgeos_core, :admin, :users]
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

    def sort
      items, search_query = forgeos_sort_from_datatables(User, %w(id full_name email active), %w(firstname lastname email))
      @users = items.search(search_query).result
    end
  end
end
