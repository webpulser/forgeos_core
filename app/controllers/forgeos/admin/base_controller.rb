module Forgeos
  class Admin::BaseController < ApplicationController
    layout 'forgeos/admin'
    helper "forgeos/admin/base"
    before_filter :login_required, :edition_locale, :except => [:notifications, :url]
    skip_after_filter :log_visit
    protect_from_forgery

  private

    def login_required
      unless current_user.is_a?(Administrator)
        store_location
        flash[:warning] = t(:login_required)
        redirect_to([forgeos_core, :admin,:login])
        return false
      end
      unless current_user.access_path?(params[:controller], params[:action])
        store_location
        flash[:warning] = t(:admin_access_denied)
        if current_user.access_path?('forgeos/admin/dashboard','index')
          redirect_to([forgeos_core, :admin,:root])
        else
          redirect_to([forgeos_core, :admin, :login])
        end
        return false
      end
    end

    def edition_locale
      if session[:lang]
        Globalize.locale = session[:lang]
      end
    end
  end
end
