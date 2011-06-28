# Load Haml and Sass
require 'haml'
require 'sass'
require 'sass/plugin'
Haml.init_rails(binding)
if Rails.env == 'production'
  Haml::Template.options[:ugly] = true
  Sass::Plugin.options[:style] = :compressed
  Sass::Plugin.options[:debug_info] = false
else
  Sass::Plugin.options[:style] = :compact
  Sass::Plugin.options[:debug_info] = true
end
