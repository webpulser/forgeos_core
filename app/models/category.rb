class Category < ActiveRecord::Base
  translates :name, :description, :url
  acts_as_tree :order => "position"
  has_and_belongs_to_many_attachments
  acts_as_list :scope => [:type]
  #validates_presence_of :name

  validates_each :parent_id do |record, attr, value|
    record.errors.add(attr, 'Can\'t be his self parent') if record.id == value
  end

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
    ([elements.count('id')] + children.all(:select => 'id,type').map(&:total_elements_count)).sum
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
     hash[:children] = children.all(:order => 'position ASC').collect(&:to_jstree)
    end
    hash
  end

  def descendants
    (children + children.map(&:descendants)).flatten
  end
end
