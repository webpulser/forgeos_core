class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all

  protect_from_forgery
  
  before_filter :set_locale

  private

  def set_locale
    if !params[:locale].nil? && I18n.available_locales.include?(params[:locale].to_sym)
      if session[:locale] != params[:locale]
        session[:locale] = params[:locale]
      end
    elsif !session[:locale]
      session[:locale] = I18n.default_locale
    end
    I18n.locale = session[:locale]
  end
end
