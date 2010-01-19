class RemoveTranslationsToCategories < ActiveRecord::Migration
  def self.up
    remove_column :categories, :name
  end

  def self.down
  end
end
