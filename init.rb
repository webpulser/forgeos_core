I18n.load_path += Dir[File.join(RAILS_ROOT, 'vendor', 'plugins', 'forgeos_core', 'config', 'locales', '**', '*.{rb,yml}')]

# Specify gems to use
config.gem 'bcrypt-ruby', :lib => 'bcrypt'
config.gem 'authlogic'
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

if ActiveRecord::Base.connection.tables.include?(Setting.table_name) && settings = Setting.first
  config.time_zone = settings.time_zone
  I18n.default_locale = settings.lang.to_sym
  ActionMailer::Base.delivery_method = settings.mailer ? settings.mailer.delivery_method : :smtp
  ActionMailer::Base.smtp_settings = settings.smtp_settings
  ActionMailer::Base.sendmail_settings = settings.sendmail_settings
end
