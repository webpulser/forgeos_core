class Admin::SettingsController < Admin::BaseController
  before_filter :get_setting, :only => [:edit, :update]
  def show
    redirect_to(:action => :edit)
  end

  def edit
    @setting.build_address unless @setting.address
  end
  
  def update
    if @setting.update_attributes(params[:setting])
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
