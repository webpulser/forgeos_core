module Forgeos
  class GeoZone < ActiveRecord::Base
    acts_as_tree
    validates :name, :presence => true

    def to_jstree(element_to_count = nil)
      hash = {
        :attributes => {
          :id => "#{self.class.to_s.underscore}_#{id}",
          :type => 'folder'
        },
        :data => {
          :title => name,
          :attributes => {
            :class => 'big-icons',
            :style => 'category_picture'
          }
        }
      }

      hash[:data][:title] += "<span>#{self.send(element_to_count).count}</span>".html_safe if element_to_count

      hash[:children] = children.map{ |g| g.to_jstree(element_to_count)} unless children.empty?

      hash
    end
  end
end
