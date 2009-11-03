class Category < ActiveRecord::Base
  acts_as_tree
  has_and_belongs_to_many :attachments, :list => true, :order => 'position', :join_table => 'attachments_elements', :foreign_key => 'element_id'
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
    return 0 if self.elements.empty? & children.empty?
    ([self.elements.size] + children.collect(&:total_elements_count)).sum
  end
  
  def category_picture
    unless self.attachments.empty?
      "background-image: url('#{self.attachments.first.public_filename(:categories_icon)}') !important;background-position: 0 3px"
    else
      ''
    end
  end

  def to_jstree
    hash = {}
    hash[:attributes] = { :id => "#{self.class.to_s.underscore}_#{id}", :type => 'folder' }
    hash[:data] = { :title => "#{name}<span>#{total_elements_count}</span>", :attributes => { :class => 'big-icons', :style => category_picture }}
    unless children.empty?
     hash[:children] = children.collect(&:to_jstree)
    end
    hash
  end
  
end
