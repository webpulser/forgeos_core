class Admin::SettingsController < Admin::BaseController
  before_filter :get_setting, :only => [:edit, :update]
  def show
    redirect_to(:action => :edit)
  end

  def edit
    @setting.build_address unless @setting.address
  end

  def update
    settings = params[:setting]
    if settings
      smtp_settings = settings[:smtp_settings]
      if smtp_settings and settings[:smtp_settings][:authentication] == 'none'
        [:authentication, :password, :user_name].each do |key|
          smtp_settings[key] = nil
        end
      end
    end
    if @setting.update_attributes(settings)
      flash[:notice] = t('setting.update.success')
    else
      flash[:error] = t('setting.update.failed')
    end
    render :action => :edit
  end
private

  def get_setting
    @setting = Setting.first
  end
end
