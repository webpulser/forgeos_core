class AddPositionToCategoriesx < ActiveRecord::Migration
  def self.up
    add_column :forgeos_categories, :position, :int, :default => 0
  end

  def self.down
    remove_column :forgeos_categories, :position
  end
end
