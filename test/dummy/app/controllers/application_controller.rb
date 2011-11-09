load File.join(Gem.loaded_specs['forgeos_core'].full_gem_path, 'app', 'controllers', 'application_controller.rb')
ApplicationController.class_eval do
  protect_from_forgery

  def keep_flash_test
    render :nothing => true
  end


  before_filter :login_required, :only => [:login_required_test]
  def login_required_test
    render :nothing => true
  end
end
