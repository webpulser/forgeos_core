class RoleCategory < Category
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :elements, :class_name => 'Role'
end
