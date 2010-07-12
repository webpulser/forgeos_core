class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation

  before_filter :set_locale
  after_filter :discard_flash_if_xhr
private

  def set_locale
    session[:locale] = current_user.lang if current_user && current_user.lang
    session[:detected_locale] = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first if request.env['HTTP_ACCEPT_LANGUAGE']
    locale = params[:locale] || session[:locale] || session[:detected_locale] || I18n.default_locale
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

protected

  def discard_flash_if_xhr
    flash.discard if request.xhr?
  end
end
