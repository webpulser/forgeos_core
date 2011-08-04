namespace :forgeos do
  namespace :core do
    desc "load fixtures and generate forgeos_core controllers ACLs"
    task :install do
      Rake::Task['forgeos:core:fixtures:load'].invoke('forgeos_core','people geo_zones settings')
      Rake::Task['forgeos:core:generate:acl'].invoke(Gem.loaded_specs['forgeos_core'].full_gem_path)
    end
  end
end
