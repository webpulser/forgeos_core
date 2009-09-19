class AddPersonIdToAttachment < ActiveRecord::Migration
  def self.up
    add_column :attachments, :person_id, :integer
  end

  def self.down
    remove_column :attachments, :person_id
  end
end
