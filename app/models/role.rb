class Role < ActiveRecord::Base
  has_many :administrators
  has_and_belongs_to_many :rights

  validates :name, :presence => true

  has_and_belongs_to_many :categories, :readonly => true, :join_table => 'categories_elements', :foreign_key => 'element_id', :association_foreign_key => 'category_id'

  define_index do
    indexes name, :sortable => true
  end

  def activate
    self.update_attribute('active', !self.active)
  end
end
