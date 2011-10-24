class RemoveTranslationsToMetaInfo < ActiveRecord::Migration
  def self.up
    remove_column :meta_infos, :title
    remove_column :meta_infos, :keywords
    remove_column :meta_infos, :description
  end

  def self.down
  end
end
