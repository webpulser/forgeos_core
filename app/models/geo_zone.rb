class GeoZone < ActiveRecord::Base
  acts_as_tree

  def to_jstree(element_to_count)
    hash = {}
    hash[:attributes] = { :id => "#{self.class.to_s.underscore}_#{id}", :type => 'folder' }
    hash[:data] = { :title => "#{name}<span>#{self.send(element_to_count).count}</span>", :attributes => { :class => 'big-icons', :style => 'category_picture' }}
    unless children.empty?
      hash[:children] = children.collect{ |g| g.to_jstree(element_to_count)}
    end
    hash
  end
end
