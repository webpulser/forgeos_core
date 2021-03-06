# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require "forgeos/core/version"

Gem::Specification.new do |s|
  s.name = 'forgeos_core'
  s.version = Forgeos::Core::VERSION
  s.date = '2011-08-05'

  s.summary = 'Core of Forgeos plugins suite'
  s.description = 'Forgeos Core provide users, libraries and administration rights and roles based management'

  s.authors = ['Cyril LEPAGNOT', 'Jean Charles Lefrancois', 'Sebastien Dumont', 'Cécile Veneziani', 'Garry Ysenbaert']
  s.email = 'dev@webpulser.com'
  s.homepage = 'http://github.com/webpulser/forgeos_core'

  s.files = Dir['{app,lib,config,db,recipes}/**/*', 'README*', 'LICENSE', 'COPYING*', 'MIT-LICENSE', 'Gemfile']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 3.2.3'

  # Assets
  s.add_dependency 'haml', '>= 3.1.2'
  s.add_dependency 'sass-rails', '>= 3.1.4'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'compass-rails', '>= 1.0.2'
  s.add_dependency 'compass_twitter_bootstrap'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'requirejs-rails', '~> 0.9.0'

  # Uploads management
  s.add_dependency 'carrierwave', '~> 0.6.2'
  s.add_dependency 'carrierwave-meta', '~> 0.0.3'
  s.add_dependency 'carrierwave_backgrounder', '~> 0.0.7'
  s.add_dependency 'mime-types', '>= 1.16'
  s.add_dependency 'mini_magick', '~> 3.4'

  # Authentication
  s.add_dependency 'bcrypt-ruby', '>= 2.1.4'
  s.add_dependency 'authlogic', '>= 3.0.3'

  # Backgrounding
  s.add_dependency 'delayed_job', '>= 3.0.1'
  s.add_dependency 'delayed_job_active_record', '>= 0.3.1'

  # Views
  s.add_dependency 'nested_form', '>= 0.2.1'
  s.add_dependency 'kaminari', '>= 0.13.0'
  #s.add_dependency 'decent_exposure'
  s.add_dependency 'simple_form', '>= 2.0.2'

  # ORM extensions
  s.add_dependency 'ransack', '>= 0.6.0'
  s.add_dependency 'squeel', '>= 0.8.7'

  # Others
  s.add_dependency 'globalize3', '>= 0.1.0'
  s.add_dependency 'webpulser-habtm_list', '~> 0.1.3.1'
  s.add_dependency 'ofc2', '~> 2.0.1'
  s.add_dependency 'fastercsv', '>= 1.5.4'
  s.add_dependency 'acts-as-taggable-on', '>= 2.0.6'
  s.add_dependency 'acts_as_list', '>= 0.1.3'
  s.add_dependency 'acts_as_tree', '0.2.0'
end
