class AddTimestampsToRoles < ActiveRecord::Migration
  def self.up
    add_timestamps :roles
  end

  def self.down
    remove_timestamps :roles
  end
end
