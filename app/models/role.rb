class Role < ActiveRecord::Base
  has_many :admins
  has_and_belongs_to_many :rights

  validates_presence_of :name

  define_index do
    indexes name, :sortable => true
  end

  def activate
    self.update_attribute('active', !self.active)
  end
end
