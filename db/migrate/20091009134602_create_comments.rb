class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string   :title, :limit => 50, :default => ''
      t.text     :comment
      t.belongs_to :commentable, :polymorphic => true
      t.belongs_to  :person
      t.datetime :created_at, :null => false
    end

    add_index :comments, %w(person_id), :name => 'fk_comments_person'
  end

  def self.down
    remove_index :comments, :name => :fk_comments_person
    drop_table :comments
  end
end
