I18n.load_path += Dir[File.join(RAILS_ROOT, 'vendor', 'plugins', 'forgeos_core', 'config', 'locales', '**', '*.{rb,yml}')]

# Specify gems to use
config.gem 'ar-extensions', :source => 'http://gemcutter.org', :version => '0.9.2'
config.gem 'bcrypt-ruby', :lib => 'bcrypt', :version => '2.1.2'
config.gem 'authlogic', :source => 'http://gemcutter.org', :version => '2.1.3'
config.gem 'mime-types', :lib => 'mime/types', :version => '1.16'
config.gem 'acts_as_list', :source => 'http://gemcutter.org', :version => '0.1.2'
config.gem 'acts_as_tree', :source => 'http://gemcutter.org', :version => '0.1.1'
config.gem 'acts_as_commentable', :source => 'http://gemcutter.org', :version => '2.0.2'
config.gem 'webpulser-jrails', :source => 'http://gems.github.com', :version => '0.4.2', :lib => 'jrails'
config.gem 'webpulser-habtm_list', :source => 'http://gems.github.com', :version => '0.1.2'
config.gem 'thinking-sphinx', :lib => 'thinking_sphinx', :source => 'http://gemcutter.org', :version => '1.3.16'
config.gem 'ruleby', :source => 'http://gemcutter.org', :version => '0.6'
config.gem 'haml', :source => 'http://gemcutter.org'
config.gem 'will_paginate', :source => 'http://gemcutter.org', :version => '2.3.12'
config.gem 'fastercsv', :source => 'http://gemcutter.org', :version => '1.5.1' if RUBY_VERSION.to_f < 1.9 
config.gem "globalize2", :source => 'http://gemcutter.org', :lib => 'globalize/model/active_record'

# Load Haml and Sass
require 'haml'
Haml.init_rails(binding)
Haml::Template.options[:ugly] = true if Rails.env == :production
Sass::Plugin.options[:style] = :compact

# Add patch to ActionController to upload via Adobe Flash
ActionController::Dispatcher.middleware.insert -1, 'FlashSessionCookieMiddleware'
require 'forgeos'

if ActiveRecord::Base.connection.tables.include?(Setting.table_name) && settings = Setting.first
  config.time_zone = settings.time_zone
  I18n.default_locale = settings.lang.to_sym
  ActionMailer::Base.delivery_method = settings.mailer ? settings.mailer.delivery_method : :smtp
  ActionMailer::Base.smtp_settings = settings.smtp_settings.marshal_dump if settings.smtp_settings
  ActionMailer::Base.sendmail_settings = settings.sendmail_settings.marshal_dump if settings.sendmail_settings
end
