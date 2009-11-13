class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :set_locale

private

  def set_locale
    session[:locale] = current_user.lang if current_user
    locale = params[:locale] || session[:locale] || I18n.default_locale
    I18n.locale = locale if !locale.blank? && I18n.available_locales.include?(locale.to_sym)
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
      flash[:notice] = "You must be logged in to access this page"
      redirect_to(login_path)
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
end

AttachmentLink

Forgeos::HasSortableAttachments.each do |element|
  klass = element.to_s.singularize.camelize.constantize
  klass.send(:include,SortableAttachments)
  klass.send(:alias_method_chain, :attachment_ids=, :position)
end
