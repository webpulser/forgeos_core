module Forgeos
  class Right < ActiveRecord::Base
    has_and_belongs_to_many :roles

    has_and_belongs_to_many :categories,
      :readonly => true,
      :join_table => 'forgeos_categories_elements',
      :foreign_key => 'element_id',
      :association_foreign_key => 'category_id'

    #check that fields have data in them
    validates :name, :controller_name, :action_name, :presence => true

    define_index do
      indexes name, :sortable => true
      indexes controller_name, :sortable => true
      indexes action_name, :sortable => true
    end
  end
end
