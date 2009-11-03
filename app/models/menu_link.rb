class MenuLink < ActiveRecord::Base
  acts_as_tree

  validates_presence_of :title
  validates_presence_of :url

  belongs_to :menu
  belongs_to :target, :polymorphic => true

  accepts_nested_attributes_for :children, :allow_destroy => true

  def clone
    menu_link = super
    menu_link.children = self.children.collect(&:clone)
    return menu_link
  end
end
