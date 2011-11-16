class CreateCategoryTranslations < ActiveRecord::Migration
  def self.up
    Forgeos::Category.create_translation_table!(:url=>:string,:name=>:string,:description=>:text)
  end

  def self.down
    Forgeos::Category.drop_translation_table!
  end
end
