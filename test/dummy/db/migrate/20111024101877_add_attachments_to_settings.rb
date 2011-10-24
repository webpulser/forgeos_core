class AddAttachmentsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :attachments, :text
  end

  def self.down
    remove_column :settings, :attachments
  end
end
