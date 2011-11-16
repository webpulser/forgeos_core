class AddPositionToCategoriesElements < ActiveRecord::Migration
  def self.up
    add_column :forgeos_categories_elements, :position, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :forgeos_categories_elements, :position
  end
end
