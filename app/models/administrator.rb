class Administrator < Person
  belongs_to :role
  has_many :rights, :through => :role
  attr_accessible :right_ids, :role_id

  has_and_belongs_to_many :categories,
    :readonly => true,
    :join_table => 'categories_elements',
    :foreign_key => 'element_id',
    :association_foreign_key => 'category_id'

  def access_path?(controller,action)
    rights.find_by_controller_name_and_action_name(controller,action)
  end
end
