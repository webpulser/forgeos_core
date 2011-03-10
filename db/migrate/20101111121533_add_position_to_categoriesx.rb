class AddPositionToCategoriesx < ActiveRecord::Migration
  def self.up
    add_column :categories, :position, :int, :default => 0
  end

  def self.down
    remove_column :categories, :position
  end
end
