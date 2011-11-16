class AddDeltaToPerson < ActiveRecord::Migration
  def self.up
    add_column :forgeos_people, :delta, :boolean, :default => true,
    :null => false
  end

  def self.down
    remove_column :forgeos_people, :delta
  end
end
