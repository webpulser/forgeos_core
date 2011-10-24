class AddIndexOnCategories < ActiveRecord::Migration
  def self.up
    add_index :categories_elements, [:category_id, :element_id], :unique => true
    change_column :categories, :type, :string, :limit => 45 
    add_index :categories, [:id, :type], :unique => true
  end

  def self.down
    remove_index :categories_elements, :column => [:category_id, :element_id]
    remove_index :categories, :column => [:id, :type]
    change_column :categories, :type, :string, :limit => 255 
  end
end
