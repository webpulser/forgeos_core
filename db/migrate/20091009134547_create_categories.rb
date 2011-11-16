class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :forgeos_categories do |t|
      t.string :name,
        :type
      t.belongs_to :parent
      t.timestamps
    end
  end

  def self.down
    drop_table :forgeos_categories
  end
end
