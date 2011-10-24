class AddDescriptionAndAltToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :description, :text
    add_column :attachments, :alt, :string
  end

  def self.down
    remove_column :attachments, :alt
    remove_column :attachments, :description
  end
end
