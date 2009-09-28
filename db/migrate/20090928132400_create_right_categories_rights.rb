class CreateRightCategoriesRights < ActiveRecord::Migration
  def self.up
    create_table :right_categories_rights, :id => false do |t|
      t.belongs_to :right_category, :right
    end
  end

  def self.down
    drop_table :right_categories_rights
  end
end
