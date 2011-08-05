require 'active_record/fixtures'

namespace :forgeos do
  namespace :core do
    namespace :generate do

      desc "Generates a role per controller and a right per controller action."
      task :acl, [:path] => :environment do |t,args|

        # set project path
        # By default, plugin path
        # else path is set to the first argument provided.
        if args.path
          project_path = args.path
        else
          puts 'usage : rake forgeos:core:generate:acl[iproject_path>]'
          exit
        end

        # list admin controllers
        path = File.join(project_path, 'app', 'controllers', 'admin')

        if File.directory? path
          # create a role for each controller and its associated actions rights
          Dir.foreach(path) do |filename|
            next if filename.match(/^\./) or !filename.match(/\.rb$/) or File.directory?(File.join(path, filename))

            controller_underscore = filename.gsub(".rb", "")
            controller_name = controller_underscore.gsub("_controller", "")
            controller = ("admin/"+controller_underscore).camelize.constantize

            print "generating rights for #{controller_name} "

            unless right_category = RightCategory.find_by_name(controller_name)
              right_category = RightCategory.create( :name => controller_name )
            end

            # create a right per controller action, & link it with the right RightCategory
            controller.action_methods.reject { |action| ApplicationController.action_methods.include?(action) }.each do |action|
              right = Right.find_or_create_by_name_and_controller_name_and_action_name "#{controller_name}_#{action}", "admin/#{controller_name}", action
              right_category.elements << right if right_category.elements.all( :conditions => { :name => "#{controller_name}_#{action}" }).empty?
              print '.'
            end
            puts ' [ok]'
          end

          role = Role.first || Role.create(:name => 'super administrator')
          admin = Administrator.first

          print "associate rights to #{role.name} "
          role.update_attributes(:right_ids => Right.all(:select => :id).collect(&:id))
          puts ' [ok]'
          print "associate role to first admin "
          admin.update_attribute(:role_id,role.id)
          puts ' [ok]'
        end
        Rake::Task['forgeos:core:generate:acl'].reenable
      end
    end
  end
end
