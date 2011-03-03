namespace :forgeos do
  task :create_shared, :roles => [:web, :app] do
    run "mkdir -p #{%w(private/config db/sphinx
                    public/uploads/avatars
                    public/uploads/pdfs
                    public/uploads/videos
                    public/uploads/images
                    public/uploads/medias
                    public/uploads/docs).collect{ |dir| "#{shared_path}/#{dir}" }.join(' ')}"
  end

  task :generate_acl, :roles => [:web, :app] do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")
    run "export RAILS_ENV=#{rails_env};
    cd #{current_path};
    #{rake} forgeos:core:generate:acl[.];
    #{rake} forgeos:core:generate:acl[vendor/plugins/forgeos_core];"
  end

  task :assets, :roles => [:web, :app] do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")
    run "mkdir #{release_path}/tmp/attachment_fu"
    run "cd #{release_path}; #{rake} forgeos:core:sync RAILS_ENV=#{rails_env};"
  end
end

require 'capistrano-helpers/shared'
require 'capistrano-helpers/privates'
require 'thinking_sphinx/deploy/capistrano'

set :normalize_asset_timestamps, false

set :privates, %w(config/database.yml)
set :shared, %w(public/uploads log db/sphinx)
after 'deploy:setup', 'forgeos:create_shared'
after 'deploy:update_code', 'forgeos:assets'
after 'deploy', 'thinking_sphinx:restart'
