Rails.configuration.compass.tap do |config|
  config.add_to_sprite_load_path File.join(Gem.loaded_specs['forgeos_core'].full_gem_path, 'app', 'assets', 'images')
end
