# This controller handles the login/logout function of the site.
module Forgeos
  class Admin::PersonSessionsController < Admin::BaseController
    layout 'forgeos/admin_login'
    skip_before_filter :login_required, :only => [ :new, :create, :reset_password ]
    def new
      @person_session = PersonSession.new
    end

    def create
      @person_session = PersonSession.new(params[:person_session])
      if @person_session.save
        flash[:notice] = t('log.in.success').capitalize
      else
        flash[:error] = t('log.in.failed').capitalize
      end

      redirect_to_stored_location([forgeos_core, :admin, :root])
    end

    def destroy
      current_user_session.destroy
      flash[:notice] = t('log.out.success').capitalize
    end

    def reset_password
      user = Administrator.find_by_email(params[:email])
      if user
        generated_password = Person.generate_password(8)
        if user.update_attributes(:password => generated_password, :password_confirmation => generated_password)
          UserNotifier.delay.reset_password(user,generated_password)
          flash[:notice] = t('admin.reset_password.success').capitalize
        else
          flash[:error] = t('admin.reset_password.failed').capitalize
        end
      else
        flash[:error] = t('admin.not_exist').capitalize
      end
      redirect_to [forgeos_core, :admin, :login]
    end
  end
end
