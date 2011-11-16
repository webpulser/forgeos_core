class CreateMetaInfos < ActiveRecord::Migration
  def self.up
    create_table :forgeos_meta_infos do |t|
      t.string :title
      t.text :description,
        :keywords
      t.belongs_to :target, :polymorphic => true
    end
  end

  def self.down
    drop_table :forgeos_meta_infos
  end
end
