class RenameCommentsField < ActiveRecord::Migration
  def self.up
    remove_index :comments, :name => "fk_comments_user"
    rename_column :comments, :user_id, :person_id
    add_index :comments, ["person_id"], :name => "fk_comments_person"
  end

  def self.down
    remove_index :comments, :name => "fk_comments_person"
    rename_column :comments, :person_id, :user_id
    add_index :comments, ["user_id"], :name => "fk_comments_user"
  end
end
