namespace :forgeos do 
  namespace :core do
    desc 'copy attachments association table values into an unique table'
    task :attachments_migration => :environment do
      elements = [] <<
      Product.all <<
      User.all <<
      Attribute.all <<
      ProductType.all <<
      Category.all <<
      AttributeValue.all

      elements.flatten.each do |element|
        print "#{element.class} ##{element.id} : "
        element.attachments2 = element.attachments
        if element.save
          puts 'ok'
        else
          puts element.errors.inspect
        end
      end
    end
  end
end
