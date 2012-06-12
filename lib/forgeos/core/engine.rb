require 'mime/types'
require 'bcrypt'
require 'ransack'
require 'squeel'
require 'haml'
require 'sass-rails'
require 'compass-rails'
require 'compass_twitter_bootstrap'
require 'globalize3'
require 'acts-as-taggable-on'
require 'acts_as_list'
require 'acts_as_tree'
require 'webpulser-habtm_list'
require 'kaminari'
require 'ofc2'
require 'authlogic'
require 'delayed_job'
require 'nested_form'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'flash_session_cookie_middleware'
module Forgeos
  module Core
    class Engine < Rails::Engine
      paths["config/locales"] << 'config/locales/**'
      paths["app/assets"] << 'vendor/assets'
      paths["forgeos_admin_menu"] = 'config/forgeos_admin_menu.yml'
      isolate_namespace Forgeos
      engine_name 'forgeos_core'
    end
  end
end
