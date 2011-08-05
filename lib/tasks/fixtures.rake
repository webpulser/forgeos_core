namespace :forgeos do
  namespace :core do
    namespace :fixtures do
      desc "Load seed fixtures (from db/fixtures) into the current environment's database."
      task :load, [:plugin_name, :tables] => :environment do |t,args|
        require 'active_record/fixtures'

        if args.plugin_name && args.tables
          PLUGIN_PATH = Gem.loaded_specs[args.plugin_name].full_gem_path
          tables = args.tables.split(' ')
        else
          puts "usage: rake forgeos:core:fixtures:load[PLUGIN_NAME,table_name1,table_name2];"
          exit
        end

        tables.each do |file|
          file_name = File.basename(file, '.yml')
          begin
            Fixtures.create_fixtures(File.join(PLUGIN_PATH,'db','fixtures'), file_name)
            puts "Loaded #{file_name} fixtures"
          rescue
            puts "#{file_name} fixtures not loaded"
          end
        end
        Rake::Task['forgeos:core:fixtures:load'].reenable
      end

      desc 'Create YAML test fixtures from data in an existing database.
      Defaults to development database. Set RAILS_ENV to override.'
      task :extract => :environment do
        PLUGIN_PATH = Gem.loaded_specs['forgeos_core'].full_gem_path

        skip_tables = ["schema_info", "sessions"]
        ActiveRecord::Base.establish_connection

        unless ARGV[1].nil? && ARGV[1].blank?
          tables = (ARGV[1]== 'all') ? ActiveRecord::Base.connection.tables - skip_tables : ARGV[1].split(',')
        else
          puts "usage: rake forgeos:core:fixtures:extract table_name1,table_name2;"
          exit
        end

        sql = "SELECT * FROM `%s`"
        tables.each do |table_name|
          i = "000"
          begin
            File.open(File.join(PLUGIN_PATH,'db','fixtures',"#{table_name}.yml"), 'w') do |file|
              puts "extract #{table_name}"
              data = ActiveRecord::Base.connection.select_all(sql % table_name)
              file.write data.inject({}) { |hash, record|
                hash["#{table_name}_#{i.succ!}"] = record
                hash["#{table_name}_#{i}"].delete('id')
                hash["#{table_name}_#{i}"].delete('created_at')
                hash["#{table_name}_#{i}"].delete('updated_at')
                hash
              }.rehash.to_yaml
            end
          rescue
            puts "#{table_name} can't be extracted"
          end
        end
      end
    end
  end
end
