class Administrator < Person
  belongs_to :role
  #has_many :rights, :through => :role
  has_and_belongs_to_many :admin_categories, :readonly => true, :join_table => 'categories_elements', :foreign_key => 'element_id', :association_foreign_key => 'category_id'

  attr_accessible :right_ids, :role_id
  before_create :activate
  delegate :rights, :right_ids, :to => :role
end 
