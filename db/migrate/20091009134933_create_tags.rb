class CreateTags < ActiveRecord::Migration
  def change
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
end
