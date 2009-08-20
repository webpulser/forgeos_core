class AddActiveStatusToRoles < ActiveRecord::Migration
  def self.up
    add_column :roles, :active, :boolean, :default => true
  end

  def self.down
    remove_column :roles, :active
  end
end
