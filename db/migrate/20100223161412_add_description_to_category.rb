class AddDescriptionToCategory < ActiveRecord::Migration
  def self.up
    add_column :category_translations, :description, :text
  end

  def self.down
    remove_column :category_translations, :description
  end
end
