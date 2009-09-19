class Admin < Person
  belongs_to :role
  #has_many :rights, :through => :role
  attr_accessible :right_ids, :role_id
  before_create :activate
  delegate :rights, :right_ids, :to => :role
end 
