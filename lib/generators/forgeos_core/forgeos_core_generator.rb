# lib/generators/authr/authr_generator.rb
require 'rails/generators'
require 'rails/generators/migration'

class ForgeosCoreGenerator < Rails::Generators::Base
 include Rails::Generators::Migration
  
  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'db/migrate')
  end
   
 # Implement the required interface for Rails::Generators::Migration.
 # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
 def self.next_migration_number(dirname)
   if ActiveRecord::Base.timestamped_migrations
    "%.3d" % (current_migration_number(dirname) + 1)
   else
     "%.3d" % (current_migration_number(dirname) + 1)
   end
 end

 def create_migration_file
   p 'here'
   
   Dir.glob(File.join(File.dirname(__FILE__),"..","..","..","db", "migrate", "*")).each do |file|
    filename = file.split('/').last
    filename_without_date = filename[15..filename.length-1]
    p filename_without_date
    migration_template file, "db/migrate/#{filename_without_date}"
  end
 end
end