class Role < ActiveRecord::Base
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :rights

  validates_presence_of :name

  define_index do
    indexes name, :sortable => true
  end
end
