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

    if element_to_count
      hash[:data][:title] += "<span>#{self.send(element_to_count).count}</span>".html_safe
    end

    unless children.empty?
      hash[:children] = children.collect{ |g| g.to_jstree(element_to_count)}
    end
    hash
  end
end
