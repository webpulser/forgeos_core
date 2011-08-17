class ApplicationController < ActionController::Base
  helper :application
  helper_method :current_user_session, :current_user

  before_filter :set_locale, :set_time_zone
  after_filter :discard_flash_if_xhr, :log_visit

  def notifications
    @notifications = {}
    [:error, :notice, :warning].each do |key|
      @notifications[key] = flash[key] unless flash[key].blank?
    end
    render :json => @notifications.to_json
  end

  private

  def set_locale
    session[:locale] = current_user.lang if current_user && current_user.lang
    session[:detected_locale] = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first if request.env['HTTP_ACCEPT_LANGUAGE']
    locale = params[:locale] || session[:locale] || session[:detected_locale] || I18n.default_locale
    if locale.present? and I18n.available_locales.include?(locale.to_sym)
      session[:locale] = I18n.locale = locale
    end
  end

  def set_time_zone
    Time.zone = current_user.time_zone if current_user and current_user.time_zone
  end

  def log_visit
    unless cookies[:visitor_counter]
      VisitorCounter.new.increment_counter
      cookies[:visitor_counter] = { :value => true, :expire => Date.current.end_of_day }
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = PersonSession.find
  end

  def current_user
    session_key = Rails.application.config.session_store
    unless defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    cookies["#{session_key}_admin"] = @current_user.is_a?(Administrator)
    return @current_user
  end

  def logged_in?
    current_user
  end

  def login_required
    unless current_user
      store_location
      flash[:notice] = t('login_required')
      redirect_to([forgeos_core, :login])
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_to_stored_location(default_path = [forgeos_core, :login], &block)
    if redirect = session[:return_to]
      session[:return_to] = nil
      redirect_to(redirect)
    else
      if block_given?
        yield
      else
        redirect_to(default_path)
      end
    end
  end

  def discard_flash_if_xhr
    flash.discard if request.xhr?
  end
end
