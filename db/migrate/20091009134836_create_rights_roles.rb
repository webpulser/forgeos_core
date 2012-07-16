class CreateRightsRoles < ActiveRecord::Migration
  def self.up
    create_table :forgeos_rights_forgeos_roles, :id => false do |t|
      t.belongs_to :right,
        :role
    end
  end

  def self.down
    drop_table :forgeos_rights_forgeos_roles
  end
end
