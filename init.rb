require 'sortable_pictures'
config.gem 'haml'
# Load Haml and Sass
require 'haml'
Haml.init_rails(binding)
config.gem 'mime-types', :lib => 'mime/types'
config.gem 'mislav-will_paginate', :source => "http://gems.github.com", :lib => "will_paginate"
config.gem 'coupa-acts_as_list', :source => "http://gems.github.com"
config.gem 'coupa-acts_as_tree', :source => "http://gems.github.com"
config.gem "mbleigh-acts-as-taggable-on", :source => "http://gems.github.com", :lib => "acts-as-taggable-on"
config.gem 'jimiray-acts_as_commentable', :source => "http://gems.github.com", :lib => 'acts_as_commentable'

ActionController::Dispatcher.middleware.insert 0, 'FlashSessionCookieMiddleware'
