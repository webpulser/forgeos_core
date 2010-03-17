I18n.load_path += Dir[File.join(RAILS_ROOT, 'vendor', 'plugins', 'forgeos_core', 'config', 'locales', '**', '*.{rb,yml}')]

# Specify gems to use
config.gem 'ar-extensions', :version => '>=0.9.2'
config.gem 'bcrypt-ruby', :lib => 'bcrypt', :version => '>=2.1.2'
config.gem 'authlogic', :version => '>=2.1.3'
config.gem 'fastercsv', :version => '>=1.5.1'
config.gem 'haml', :version => '>=2.2.15'
config.gem 'will_paginate', :version => '>2.3.11'
config.gem 'mime-types', :lib => 'mime/types', :version => '>=1.16'
config.gem 'acts_as_list', :version => '>=0.1.2'
config.gem 'acts_as_tree', :version => '>=0.1.1'
config.gem 'acts_as_commentable', :version => '3.0.0'
config.gem 'webpulser-jrails', :source => 'http://gems.github.com', :version => '0.4.2', :lib => 'jrails'
config.gem 'webpulser-habtm_list', :source => 'http://gems.github.com', :version => '0.1.2'
config.gem 'thinking-sphinx', :lib => 'thinking_sphinx', :version => '>=1.3.14'
config.gem 'ruleby', :version => '0.6'

require 'forgeos'

if ActiveRecord::Base.connection.tables.include?(Setting.table_name) && settings = Setting.first
  config.time_zone = settings.time_zone
  I18n.default_locale = settings.lang.to_sym
  ActionMailer::Base.delivery_method = settings.mailer ? settings.mailer.delivery_method : :smtp
  ActionMailer::Base.smtp_settings = settings.smtp_settings
  ActionMailer::Base.sendmail_settings = settings.sendmail_settings
end
