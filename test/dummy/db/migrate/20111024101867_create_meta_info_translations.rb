class CreateMetaInfoTranslations < ActiveRecord::Migration
  def self.up
    MetaInfo.create_translation_table!(:title=>:string,:description=>:text,:keywords=>:text)
  end

  def self.down
    MetaInfo.drop_translation_table!
  end
end
