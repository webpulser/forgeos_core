class Category < ActiveRecord::Base
  acts_as_tree
  
  # TODO
  #has_and_belongs_to_many :attachments, :list => true, :order => 'position'
  
  validates_presence_of :name

  # Returns the level of <i>Category</i>
  def level
    return self.ancestors.length
  end

  def kind
    read_attribute(:type)
  end
  
  def kind=(kind)
    write_attribute(:type, kind)
  end

  def total_elements_count
    ([self.elements.count] + children.collect(&:total_elements_count)).inject(:+)
  end

  def elements
    []
  end

  def to_jstree
    hash = {}
    hash[:attributes] = { :id => "#{self.class.to_s.underscore}_#{id}", :type => 'folder' }
    hash[:data] = { :title => "#{name}<span>#{total_elements_count}</span>", :attributes => { :class => 'big-icons' } }
    unless children.empty?
     hash[:children] = children.collect(&:to_jstree)
    end
    hash
  end
end
