require 'rails'
require 'globalize3'
require 'acts-as-taggable-on'
require 'acts_as_list'
require 'acts_as_tree'
require 'bcrypt'
require 'haml'
require 'sass'
require 'thinking-sphinx'
require 'webpulser-habtm_list'
require 'will_paginate'
require 'authlogic'
require 'squeel'
require 'delayed_job'

module Forgeos
  module Core
    class Engine < Rails::Engine
      paths["config/locales"] << 'config/locales/**'
      paths["app/assets"] << 'vendor/assets'
      paths["forgeos_admin_menu"] = 'config/forgeos_admin_menu.yml'
    end
  end
end
