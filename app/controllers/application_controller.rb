class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :set_locale

private

  def set_locale
    session[:locale] = current_user.lang if current_user && current_user.lang
    locale = params[:locale] || request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first || session[:locale] || I18n.default_locale
    if !locale.blank? && I18n.available_locales.include?(locale.to_sym)
      session[:locale] = I18n.locale = locale
      ActiveRecord::Base.locale=locale
    end
  end


  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = PersonSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def logged_in?
    current_user
  end

  def login_required
    unless current_user
      store_location
      flash[:notice] = t('login_required')
      redirect_to(login_path)
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
end
