class AddAttachmentsToSettings < ActiveRecord::Migration
  def self.up
    add_column :forgeos_settings, :attachments, :text
  end

  def self.down
    remove_column :forgeos_settings, :attachments
  end
end
