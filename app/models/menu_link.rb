class MenuLink < ActiveRecord::Base
  acts_as_tree

  validates_presence_of :title
  validates_presence_of :url

  belongs_to :menu
end
