class RemoveTranslationsToMetaInfo < ActiveRecord::Migration
  def self.up
    remove_column :forgeos_meta_infos, :title
    remove_column :forgeos_meta_infos, :keywords
    remove_column :forgeos_meta_infos, :description
  end

  def self.down
  end
end
