load File.join(Gem.loaded_specs['forgeos_core'].full_gem_path, 'app', 'controllers', 'admin', 'base_controller.rb')
Admin::BaseController.class_eval do
  skip_before_filter :login_required, :only => [:edition_locale_test]
  def edition_locale_test
    render :nothing => true
  end

  def login_require_test
    render :nothing => true
  end
end
