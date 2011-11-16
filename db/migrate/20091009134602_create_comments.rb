class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :forgeos_comments do |t|
      t.string   :title, :limit => 50, :default => ''
      t.text     :comment
      t.belongs_to :commentable, :polymorphic => true
      t.belongs_to :person
      t.timestamps
    end

    add_index :forgeos_comments, %w(person_id), :name => 'fk_comments_person'
  end

  def self.down
    remove_index :forgeos_comments, :name => :fk_comments_person
    drop_table :forgeos_comments
  end
end
