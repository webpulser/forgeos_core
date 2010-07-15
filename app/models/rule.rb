class Rule < ActiveRecord::Base
  acts_as_tree
  before_save :usage
  serialize :variables

  validates_presence_of :name, :conditions

  def usage
    #activated = false if max_use && max_use > 0 && use >= max_use
    #self.active = true
  end

  def activate
    self.update_attribute(:active, !self.active?)
  end

  def name
    return super unless parent
    super || parent.name
  end

  def description
    return super unless parent
    super || parent.description
  end
end
