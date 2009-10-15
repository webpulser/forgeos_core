# This controller handles the login/logout function of the site.  
class Admin::SessionsController < Admin::BaseController
  layout 'admin_login'
  skip_before_filter :login_required, :only => [:new, :create]
  def new
    session[:redirect] = nil
  end

  def create
    self.current_user = Admin.authenticate(params[:email], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      if redirect = session[:redirect]
        session[:redirect] = nil
        redirect_to(redirect)
      else
        redirect_to(:root)
      end
      flash[:notice] = I18n.t('log.in.success').capitalize
    else
      flash[:error] = I18n.t('log.in.failed').capitalize
      if redirect = session[:redirect]
        session[:redirect] = nil
        redirect_to(redirect)
      else
        redirect_to :action => 'new'
      end
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = I18n.t('log.out.success').capitalize
  end
end
