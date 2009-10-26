# This controller handles the login/logout function of the site.  
class Admin::SessionsController < Admin::BaseController
  layout 'admin_login'
  skip_before_filter :login_required, :only => [:new, :create, :reset_password, :reset_admin_password]
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
  
  def reset_admin_password
    user = Admin.find_by_email(params[:email])
    if user
      generated_password = generate_password(8)
      if user.update_attributes(:password => generated_password, :password_confirmation => generated_password)
        UserNotifier.deliver_reset_password(user,generated_password)
        flash[:notice] = I18n.t('admin.reset_password.success').capitalize
      else
        flash[:error] = I18n.t('admin.reset_password.failed').capitalize
      end
    else
      flash[:error] = I18n.t('admin.not_exist').capitalize
    end
    redirect_to :action => 'new'
  end
  
private
  def generate_password(size)
    s = ""
    size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    return s    
  end

end
