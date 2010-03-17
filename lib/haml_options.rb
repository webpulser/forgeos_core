# Load Haml and Sass
require 'haml'
Haml.init_rails(binding)
if Rails.env == :production
  Haml::Template.options[:ugly] = true 
  Sass::Plugin.options[:style] = :compressed
else
  Sass::Plugin.options[:style] = :compact
end
