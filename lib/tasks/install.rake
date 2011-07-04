namespace :forgeos do
  namespace :core do
    desc "load fixtures and generate forgeos_core controllers ACLs"
    task :install => [ :environment, 'forgeos_core_engine:install:migrations', 'db:migrate' ] do
      system 'rake "forgeos:core:fixtures:load[forgeos_core,people geo_zones settings]"'
      system "rake 'forgeos:core:generate:acl[#{Gem.loaded_specs['forgeos_core'].full_gem_path}]'"
    end
  end
end
