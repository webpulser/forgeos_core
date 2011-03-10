class Admin::DashboardController < Admin::BaseController
  def index; end

  def change_lang
    if params[:lang] && I18n.available_locales.include?(params[:lang].to_sym)
      session[:lang] = params[:lang].to_sym
    end
    redirect_to(:back)
  end
end
