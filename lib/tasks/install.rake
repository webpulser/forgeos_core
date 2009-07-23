namespace :forgeos_core do
  task :sync do
    system 'rsync -rvC vendor/plugins/forgeos_core/public .'
  end

  task :initialize => [ 'db:migrate' ] do
    #email = ARGV[1]
    #Admin.new(:email => {}, :first_name => 'admin', :last_name => 'admin', :passord => , :passord_confirmation => )
  end

  task :install => [ 'gems:install', :initialize, :sync]
end
