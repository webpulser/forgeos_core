class CreateCategoriesElements < ActiveRecord::Migration
  def self.up
    create_table :categories_elements, :id => false do |t|
      t.belongs_to :category, :element
    end
  end

  def self.down
    drop_table :categories_elements
  end
end
