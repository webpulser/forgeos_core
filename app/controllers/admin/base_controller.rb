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
    unless current_user.is_a?(Administrator)
      store_location
      flash[:warning] = t(:login_required)
      redirect_to(admin_login_path)
      return false
    end
    unless current_user.access_path?(params[:controller], params[:action])
      store_location
      flash[:warning] = t(:admin_access_denied)
      if current_user.access_path?('admin/dashboard','index')
        redirect_to(admin_root_path)
      else
        redirect_to(admin_login_path)
      end
      return false
    end
  end
end
