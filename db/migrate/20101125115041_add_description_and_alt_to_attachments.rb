class AddDescriptionAndAltToAttachments < ActiveRecord::Migration
  def self.up
    add_column :forgeos_attachments, :description, :text
    add_column :forgeos_attachments, :alt, :string
  end

  def self.down
    remove_column :forgeos_attachments, :alt
    remove_column :forgeos_attachments, :description
  end
end
