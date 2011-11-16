class CreateMetaInfoTranslations < ActiveRecord::Migration
  def self.up
    Forgeos::MetaInfo.create_translation_table!(:title=>:string,:description=>:text,:keywords=>:text)
  end

  def self.down
    Forgeos::MetaInfo.drop_translation_table!
  end
end
