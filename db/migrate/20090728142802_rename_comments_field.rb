class RenameCommentsField < ActiveRecord::Migration
  def self.up
    rename_column :comments, :user_id, :person_id
    remove_index :comments, ["user_id"]
    add_index :comments, ["person_id"], :name => "fk_comments_person"
  end

  def self.down
    rename_column :comments, :person_id, :user_id
    remove_index :comments, ["person_id"]
    add_index :comments, ["user_id"], :name => "fk_comments_user"
  end
end
