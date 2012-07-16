require File.join(File.dirname(__FILE__), 'dependencies')

module Forgeos
  module Core
    class Engine < Rails::Engine
      paths["config/locales"] << 'config/locales/**/*'
      paths["app/assets"] << 'vendor/assets'
      paths["forgeos_admin_menu"] = 'config/forgeos_admin_menu.yml'

      isolate_namespace Forgeos
      engine_name 'forgeos_core'

      initializer 'forgeos_core.autoload', :before => :set_autoload_paths do |app|
        app.config.eager_load_paths << File.expand_path("../../../../app/presenters", __FILE__)
      end
    end
  end
end

