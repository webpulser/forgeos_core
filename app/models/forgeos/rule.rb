module Forgeos
  class Rule < ActiveRecord::Base
    acts_as_tree
    serialize :variables

    validates :name, :conditions, :presence => true

    before_save :usage

    def activate
      activation_state = !self.active?
      self.update_attribute(:active, activation_state)
      children.each do |child|
        child.update_attribute(:active,activation_state)
      end
    end

    def description
      return super unless parent
      super || parent.description
    end

    def name
      return super unless parent
      super || parent.name
    end

    def usage
      #activated = false if max_use && max_use > 0 && use >= max_use
      #self.active = true
    end
  end
end
