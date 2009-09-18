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
end
