class CreateRightsRoles < ActiveRecord::Migration
  def self.up
    create_table :rights_roles, :id => false do |t|
      t.integer :right,
        :role
    end
  end

  def self.down
    drop_table :rights_roles
  end
end
