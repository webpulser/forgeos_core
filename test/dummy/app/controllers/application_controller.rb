load File.join(Gem.loaded_specs['forgeos_core'].full_gem_path, 'app', 'controllers', 'application_controller.rb')
ApplicationController.class_eval do
  protect_from_forgery
end
