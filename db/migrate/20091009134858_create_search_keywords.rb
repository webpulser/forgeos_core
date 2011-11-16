class CreateSearchKeywords < ActiveRecord::Migration
  def self.up
    create_table :forgeos_search_keywords do |t|
      t.string :keyword
      t.timestamps
    end
  end

  def self.down
    drop_table :forgeos_search_keywords
  end
end
