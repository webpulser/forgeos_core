class RenameSortablePicturesToSortableAttachments < ActiveRecord::Migration
  def self.up
    rename_table :sortable_pictures, :sortable_attachments
    rename_column :sortable_attachments, :picture_id, :attachment_id
    rename_column :sortable_attachments, :picturable_id, :attachable_id
    rename_column :sortable_attachments, :picturable_type, :attachable_type
  end

  def self.down
    rename_table :sortable_attachments, :sortable_pictures
    rename_column :sortable_pictures, :attachment_id, :picture_id
    rename_column :sortable_pictures, :attachable_id, :picturable_id
    rename_column :sortable_pictures, :attachable_type, :picturable_type
  end
end
