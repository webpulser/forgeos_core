class Admin::BaseController < ApplicationController
  include AuthenticatedSystem
  layout 'admin'
  #before_filter :login_required

  def notifications
    @notifications = {}
    [:error, :notice, :warning].each do |key|
      @notifications[key] = flash.delete(key)
    end
    render :json => @notifications.to_json
  end
end
