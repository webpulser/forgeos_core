namespace :forgeos do
  namespace :core do
    namespace :generate do

      desc "Generates a role per controller and a right per controller action."
      task :acl, [:plugin] => :environment do |t,args|

        # set project path
        # By default, plugin path
        # else path is set to the first argument provided.
        if args.plugin
          target = Rails.application.railties.engines.find { |en| en.engine_name == args.plugin } || Rails.application
          project_path = target.root
          controller_path = File.join(project_path, 'app', 'controllers')
        else
          puts 'usage : rake forgeos:core:generate:acl[<plugin_name_or_app>]'
          exit
        end

        # list admin controllers
        Dir[File.join(controller_path, '**', 'admin', '*')].each do |filename|
          next if filename.match(/^\./) or not filename.match(/\.rb$/) or File.directory?(filename)

          controller_underscore = filename.gsub("#{controller_path}/", "").gsub(".rb", "")
          controller_name = controller_underscore.gsub("_controller", "")
          controller = controller_underscore.camelize.constantize

          print "generating rights for #{controller_name} "

          unless right_category = Forgeos::RightCategory.find_by_name(controller_name)
            right_category = Forgeos::RightCategory.create( :name => controller_name )
          end

          # create a right per controller action, & link it with the right RightCategory
          controller.action_methods.reject { |action| Forgeos::ApplicationController.action_methods.include?(action) }.each do |action|
            right = Forgeos::Right.find_or_create_by_name_and_controller_name_and_action_name "#{controller_name}_#{action}", controller_name, action
            right_category.elements << right if right_category.elements.all( :conditions => { :name => "#{controller_name}_#{action}" }).empty?
            print '.'
          end
          puts ' [ok]'
        end

        role = Forgeos::Role.first || Forgeos::Role.create(:name => 'super administrator')
        admin = Forgeos::Administrator.first

        print "associate rights to #{role.name} "
        role.update_attributes(:right_ids => Forgeos::Right.all(:select => :id).collect(&:id))
        puts ' [ok]'
        print "associate role to first admin "
        admin.update_attribute(:role_id,role.id)
        puts ' [ok]'
        Rake::Task['forgeos:core:generate:acl'].reenable
      end
    end
  end
end
