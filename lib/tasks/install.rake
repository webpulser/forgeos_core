namespace :forgeos do
  namespace :core do
    task :sync => [:environment] do
      system "rsync -r#{'v' unless Rails.env == 'production'}C #{File.join(Rails.plugins['forgeos_core'].directory,'public')} ."
    end

    task :initialize => [ :environment, 'db:migrate' ] do
      system 'rake "forgeos:core:fixtures:load[forgeos_core,people geo_zones settings]"'
      system "rake 'forgeos:core:generate:acl[#{Rails.plugins['forgeos_core'].directory}]'"
    end

    task :install => [ 'gems:install', :initialize, :sync]
  end
end
