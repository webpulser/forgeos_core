I18n.load_path += Dir[File.join(RAILS_ROOT, 'vendor', 'plugins', 'forgeos_core', 'config', 'locales', '**', '*.{rb,yml}')]

# Specify gems to use
config.gem 'mime-types', :lib => 'mime/types'
config.gem 'mislav-will_paginate', :source => "http://gems.github.com", :lib => "will_paginate"
config.gem 'coupa-acts_as_list', :source => "http://gems.github.com"
config.gem 'coupa-acts_as_tree', :source => "http://gems.github.com"
config.gem 'jimiray-acts_as_commentable', :source => "http://gems.github.com", :lib => 'acts_as_commentable'
config.gem 'webpulser-jrails', :source => "http://gems.github.com", :lib => 'jrails'
config.gem 'webpulser-habtm_list', :source => "http://gems.github.com"
config.gem 'freelancing-god-thinking-sphinx', :lib => 'thinking_sphinx', :source => "http://gems.github.com"
config.gem 'ar-extensions'
config.gem 'ruleby'
config.gem 'haml'

# Load Haml and Sass
require 'haml'
Haml.init_rails(binding)
Sass::Plugin.options[:style] = :compact

# Add patch to ActionController to upload via Adobe Flash
ActionController::Dispatcher.middleware.insert -1, 'FlashSessionCookieMiddleware'
require 'forgeos'
