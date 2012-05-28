require 'rails'
require 'mime/types'
require 'globalize3'
require 'acts-as-taggable-on'
require 'acts_as_list'
require 'acts_as_tree'
require 'bcrypt'
require 'haml'
require 'sass'
require 'webpulser-habtm_list'
require 'authlogic'
require 'squeel'
require 'ransack'
require 'kaminari'
require 'delayed_job'
require 'ofc2'

module Forgeos
  module Core
    class Engine < Rails::Engine
      paths["config/locales"] << 'config/locales/**'
      paths["app/assets"] << 'vendor/assets'
      paths["forgeos_admin_menu"] = 'config/forgeos_admin_menu.yml'
      isolate_namespace Forgeos
      engine_name 'forgeos_core_engine'
    end
  end
end
