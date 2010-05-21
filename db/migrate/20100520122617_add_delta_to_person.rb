class AddDeltaToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :delta, :boolean, :default => true,
    :null => false
  end

  def self.down
    remove_column :people, :delta
  end
end
