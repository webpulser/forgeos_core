module Forgeos
  class Role < ActiveRecord::Base
    has_many :administrators
    has_and_belongs_to_many :rights,
    :join_table => 'forgeos_rights_forgeos_roles'

    validates :name, :presence => true

    has_and_belongs_to_many :categories,
      :readonly => true,
      :join_table => 'forgeos_categories_elements',
      :foreign_key => 'element_id',
      :association_foreign_key => 'category_id'

    def activate
      self.update_attribute('active', !self.active)
    end
  end
end
