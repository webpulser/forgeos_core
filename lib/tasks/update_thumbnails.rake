namespace :forgeos do
  namespace :core do
    desc 'update pictures from modified or added thumbnails formats'
    task :update_thumbnails => :environment do
      pictures = Picture.find_all_by_parent_id(nil)
      pictures.each_with_index do |picture,i|
        puts "Fixing #{i}/#{pictures.size} : #{picture.filename}"
        temp_file = picture.create_temp_file

        picture.attachment_options[:thumbnails].each { |suffix, size|
          picture.create_or_update_thumbnail(temp_file, suffix, *size)
          puts "  #{suffix}"
        }
        #sleep 2
      end
    end
    task :update_thumbnails_with_options, [:start, :end, :thumb] => :environment do |t,options|
      unless options[:start] && options[:end] && options[:thumb]
        puts 'usage : rake forgeos:core:update_thumbnails_with_options[start,end,thumb]'
        exit
      end
      pictures = Picture.find_all_by_parent_id(nil)
      options[:start].blank? ? _start = 0 : _start = options[:start].to_i
      options[:end].blank? ? _end = (pictures.size-1) : _end = options[:end].to_i
      format = options[:thumb].to_sym

      i = _start
      pictures[_start.._end].each do |picture|
        puts "Fixing #{i}/#{_end} : #{picture.filename}"
        temp_file = picture.create_temp_file

        size = picture.attachment_options[:thumbnails][format.to_sym]
        unless size.nil?
          picture.create_or_update_thumbnail(temp_file, options[:thumb] , *size)
          puts "=> #{options[:thumb]} ...... [ok]"
        else
          puts "================================="
          puts "* cannot find this thumb format *"
          puts "================================="
          puts ""
          puts "=> below the list of thumb formats"
          picture.attachment_options[:thumbnails].keys.each do |key|
            puts "- #{key}"
          end
        end
        i = _start + 1
      end
    end
  end
end
