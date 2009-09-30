class Right < ActiveRecord::Base
  has_and_belongs_to_many :roles

  has_and_belongs_to_many :right_categories, :readonly => true, :join_table => 'categories_elements', :foreign_key => 'element_id', :association_foreign_key => 'category_id'
  
  #check that fields have data in them
  validates_presence_of :name, :controller_name, :action_name

  define_index do
    indexes name, :sortable => true
    indexes controller_name, :sortable => true
    indexes action_name, :sortable => true
  end
end
