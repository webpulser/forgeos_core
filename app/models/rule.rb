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
    activation_state = !self.active?
    self.update_attribute(:active, activation_state)
    children.each do |child|
      child.update_attribute(:active,activation_state)
    end
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
