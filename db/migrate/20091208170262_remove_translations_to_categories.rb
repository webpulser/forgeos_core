class RemoveTranslationsToCategories < ActiveRecord::Migration
  def self.up
    remove_column :forgeos_categories, :name
  end

  def self.down
  end
end
