class RightCategory < Category
  has_and_belongs_to_many :rights
  has_and_belongs_to_many :elements, :class_name => 'Right'
end
