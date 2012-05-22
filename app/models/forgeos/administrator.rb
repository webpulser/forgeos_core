module Forgeos
  class Administrator < Person
    belongs_to :role
    has_many :rights, :through => :role
    attr_accessible :right_ids, :role_id

    has_and_belongs_to_many :categories,
      :readonly => true,
      :join_table => 'forgeos_categories_elements',
      :foreign_key => 'element_id',
      :association_foreign_key => 'category_id'

    def access_path?(controller,action)
      rights.find_by_controller_name_and_action_name(controller,action).present?
    end

    define_index do
      indexes firstname, :sortable => true
      indexes lastname, :sortable => true
      indexes email, :sortable => true
      has active, :sortable => true, :type => :boolean
      indexes Administrator.sql_fullname_query, :as => :full_name, :sortable => true
      indexes role(:name), :as => :role_name, :sortable => true
      set_property :delta => true
    end
  end
end
