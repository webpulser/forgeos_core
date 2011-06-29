require 'rails'

module Forgeos
  module Core
    class Engine < Rails::Engine
      paths["config/locales"] << 'config/locales/**'
    end
  end
end
