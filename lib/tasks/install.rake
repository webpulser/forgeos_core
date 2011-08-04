namespace :forgeos do
  namespace :core do
    desc "load fixtures and generate forgeos_core controllers ACLs"
    task :install do
      puts '==========> Load Fixtures'
      Rake::Task['forgeos:core:fixtures:load'].invoke('forgeos_core','people geo_zones settings')
      puts '==========> Generate forgeos_core controllers ACLs'
      Rake::Task['forgeos:core:generate:acl'].invoke(Gem.loaded_specs['forgeos_core'].full_gem_path)
      puts '[DONE]' 
    end
  end
end
