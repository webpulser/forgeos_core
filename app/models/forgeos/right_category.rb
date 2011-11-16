module Forgeos
  class RightCategory < Category
    has_and_belongs_to_many :rights, :join_table => 'forgeos_categories_elements', :foreign_key => 'category_id', :association_foreign_key => 'element_id', :class_name => 'Forgeos::Right'
    has_and_belongs_to_many :elements, :join_table => 'forgeos_categories_elements', :foreign_key => 'category_id', :association_foreign_key => 'element_id', :class_name => 'Forgeos::Right'
  end
end
