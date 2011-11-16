module Forgeos
  class UserCategory < Category
    has_and_belongs_to_many :elements, :join_table => 'forgeos_categories_elements', :foreign_key => 'category_id', :association_foreign_key => 'element_id', :class_name => 'Forgeos::User'
  end
end
