module Forgeos
  class User < Person
    has_many :addresses, :foreign_key => 'person_id'
    accepts_nested_attributes_for :addresses
    attr_accessible :addresses_attributes

    has_and_belongs_to_many :categories,
      :readonly => true,
      :join_table => 'forgeos_categories_elements',
      :foreign_key => 'element_id',
      :association_foreign_key => 'category_id'

    def age
      ((Date.today - self.birthday) / 365).floor
    end
  end
end
