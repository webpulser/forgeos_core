class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :set_locale

private

  def set_locale
    session[:locale] = params[:locale] || session[:locale] || I18n.default_locale
    I18n.locale = session[:locale] if I18n.available_locales.include?(session[:locale].to_sym)
  end

  def redirect_to_home
    redirect_to(:root)
  end
end
