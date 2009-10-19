namespace :forgeos do
  namespace :core do
    task :sync do
      system "rsync -rvC #{File.join('vendor','plugins','forgeos_core','public')} ."
    end

    task :initialize => [ :environment, 'db:migrate' ] do
      system 'rake forgeos:core:fixtures:load forgeos_core people,geo_zones'
      system "rake forgeos:core:generate:acl #{File.join('vendor','plugins','forgeos_core')}"
    end

    task :install => [ 'gems:install', :initialize, :sync]
  end
end
