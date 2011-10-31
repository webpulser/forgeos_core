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

Forgeos::MENU_HASH = HashWithIndifferentAccess.new(menu)
