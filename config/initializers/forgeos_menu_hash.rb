menu ||= {}
Rails.application.railties.engines.each do |engine|
  if path = engine.paths['forgeos_admin_menu']
    path.expanded.each do |file|
      menu.deep_merge! YAML.load_file(file)
    end
  end
end

if path = Rails.application.paths['forgeos_admin_menu']
  path.expanded.each do |file|
    menu.deep_merge! YAML.load_file(file)
  end
end

if defined?(Forgeos::MENU_HASH)
  Forgeos::MENU_HASH.deep_merge! HashWithIndifferentAccess.new(menu)
else
  Forgeos::MENU_HASH = HashWithIndifferentAccess.new(menu)
end
