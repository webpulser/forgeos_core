class Admin::BaseController < Forgeos::ApplicationController
  layout 'admin'
  helper_method :forgeos_js_functions_files, :forgeos_js_inits_files
  before_filter :login_required, :edition_locale, :except => [:notifications, :url]
  before_filter :forgeos_core_javascripts_files
  skip_after_filter :log_visit
  protect_from_forgery

private

  def forgeos_core_javascripts_files
    @forgeos_js_functions_files = forgeos_javascripts_files('forgeos_core', 'forgeos/admin/functions')
    @forgeos_js_inits_files = forgeos_javascripts_files('forgeos_core', 'forgeos/admin/inits')
  end

  def forgeos_javascripts_files(plugin_name, dir)
    asset_dir = File.join(Gem.loaded_specs[plugin_name].full_gem_path, 'app', 'assets', 'javascripts')
    Dir[File.join([asset_dir, dir, '**','*.js'].compact)].collect do |file|
      file[-(file.size - asset_dir.size - 1)..-1].sub(/\.\w+$/, '')
    end.sort
  end

  def forgeos_js_functions_files
    @forgeos_js_functions_files || []
  end

  def forgeos_js_inits_files
    @forgeos_js_inits_files || []
  end

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
      if current_user.access_path?('admin/dashboard','index')
        redirect_to([forgeos_core, :admin,:root])
      else
        redirect_to([forgeos_core, :admin, :login])
      end
      return false
    end
  end

  def edition_locale
    if session[:lang]
      ActiveRecord::Base.locale = session[:lang]
    end
  end
end
