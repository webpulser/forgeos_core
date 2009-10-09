namespace :forgeos_core do
  task :sync do
    system 'rsync -rvC vendor/plugins/forgeos_core/public .'
  end

  task :initialize => [ 'db:migrate' ] do
    system 'rake forgeos_commerce:fixtures:load FIXTURES=people,geo_zones'
    system 'rake forgeos_core:generate:acl vendor/plugins/forgeos_core'
  end

  task :install => [ 'gems:install', :initialize, :sync]
end
