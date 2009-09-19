class DropAdminsRoles < ActiveRecord::Migration
  def self.up
    drop_table :admins_roles
  end

  def self.down
    create_table :admins_roles do |t|
      t.belongs_to :role,:admin
    end
  end
end
