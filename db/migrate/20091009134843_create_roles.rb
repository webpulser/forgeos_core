class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :forgeos_roles do |t|
      t.string   :name
      t.boolean  :active,
        :default => true, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :forgeos_roles
  end
end
