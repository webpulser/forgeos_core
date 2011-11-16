class AddElementTypeToAttachmentsElements < ActiveRecord::Migration
  def self.up
    change_table :forgeos_attachments_elements do |t|
      t.string :element_type,
        :attachment_type
      t.column :id, :primary_key
    end
    rename_table :forgeos_attachments_elements, :forgeos_attachment_links
  end

  def self.down
    rename_table :forgeos_attachment_links, :forgeos_attachments_elements
    remove_column :attachments_elements, :element_type
    remove_column :attachments_elements, :attachment_type
    remove_column :attachments_elements, :id
  end
end
