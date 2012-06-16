module Forgeos
  class Admin::SettingsController < Admin::BaseController
    before_filter :get_setting, :only => [:edit, :update]
    def show
      redirect_to([forgeos_core, :edit, :admin, :setting])
    end

    def edit
      @setting.build_site_address unless @setting.site_address
    end

    def update
      if @setting.update_attributes(params[:setting])
        flash[:notice] = t('setting.update.success')
        redirect_to([forgeos_core, :edit, :admin, :setting])
      else
        flash[:error] = t('setting.update.failed')
        render(:action => :edit)
      end
    end
  private

    def get_setting
      @setting = Setting.first
    end
  end
end
