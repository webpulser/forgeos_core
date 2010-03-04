class AddUrlToCategoryTranslation < ActiveRecord::Migration
  def self.up
    add_column :category_translations, :url, :string
  end

  def self.down
    remove_column :category_translations, :url
  end
end
