class AddIndexOnCategories < ActiveRecord::Migration
  def self.up
    add_index :forgeos_categories_elements, [:category_id, :element_id], :unique => true
    change_column :forgeos_categories, :type, :string, :limit => 45
    add_index :forgeos_categories, [:id, :type], :unique => true
  end

  def self.down
    remove_index :forgeos_categories_elements, :column => [:category_id, :element_id]
    remove_index :forgeos_categories, :column => [:id, :type]
    change_column :forgeos_categories, :type, :string, :limit => 255
  end
end
