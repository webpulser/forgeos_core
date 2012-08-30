namespace :forgeos do
  namespace :core do
    desc "load fixtures and generate forgeos_core controllers ACLs"
    task :install do
      Rake::Task['forgeos_core:install:migrations'].invoke
      Rake::Task['db:migrate'].invoke
      Rake::Task['forgeos:core:fixtures:load'].invoke('forgeos_core','people geo_zones settings')
      Rake::Task['forgeos:core:generate:acl'].invoke('forgeos_core')
    end
  end
end
