class Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :login_required, :except => [:notifications, :url]

  def notifications
    @notifications = {}
    [:error, :notice, :warning].each do |key|
      @notifications[key] = flash.delete(key)
    end
    render :json => @notifications.to_json
  end

private
  def login_required
    unless current_user.is_a?(Administrator) && current_user.rights.find_by_controller_name_and_action_name(params[:controller], params[:action])
      store_location
      flash[:warning] = "You must be logged in to access this page"
      redirect_to(admin_login_path)
      return false
    end
  end
end
