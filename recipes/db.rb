namespace :db do
  desc 'Get SQL dump of the current database'
  task :get_dump, :roles => :app do
    filename = capture("ls -c1 dump_#{application}_#{stage}_*.sql | head -1").strip
    get(filename, "/tmp/#{filename}")
  end

  namespace :mysql do
    desc 'Backup the current database'
    task :backup, :roles => :app do
      # Get MySQL params
      database_yml = ""
      run "cat #{current_path}/config/database.yml" do |_, _, database_yml| end
      db = YAML::load(database_yml)['production']
      mysql_options = "-u #{db['username']} --password=#{db['password']} #{db['database']}"
      mysql_options = "-h #{db['host']} #{mysql_options}" if db['host']
      mysql_options = "-P #{db['port']} #{mysql_options}" if db['port']
      # Set paths
      now = Time.now.strftime('%Y%m%d%H%M%S')
      filename = "dump_#{application}_#{stage}_#{now}.sql"
      dump_path = "~#{user}/#{filename}"
      # Save dump
      run "mysqldump #{mysql_options} > #{dump_path}"
    end
  end
end

before 'db:get_dump', 'db:mysql:backup'
