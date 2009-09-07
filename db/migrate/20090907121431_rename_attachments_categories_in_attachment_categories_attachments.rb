class RenameAttachmentsCategoriesInAttachmentCategoriesAttachments < ActiveRecord::Migration
  def self.up
    rename_table :attachments_categories, :attachment_categories_attachments
    rename_column :attachment_categories_attachments, :category_id, :attachment_category_id
    remove_column :attachment_categories_attachments, :position
  end

  def self.down
    rename_column :attachment_categories_attachments, :attachment_category_id, :category_id
    add_column :attachment_categories_attachments, :position, :integer
    rename_table :attachment_categories_attachments, :attachments_categories
  end
end
