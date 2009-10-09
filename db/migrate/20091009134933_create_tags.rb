class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.belongs_to  :tag
      t.belongs_to  :taggable,
        :tagger,
        :polymorphic => true
      t.string   :context
      t.datetime :created_at
    end

    add_index :taggings, %w(tag_id)
    add_index :taggings, %w(taggable_id taggable_type context)

    create_table :tags do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :tags
    remove_index :taggings, :column => %w(taggable_id taggable_type context)
    remove_index :taggings, :column => %(tag_id)
    drop_table :taggings
  end
end
