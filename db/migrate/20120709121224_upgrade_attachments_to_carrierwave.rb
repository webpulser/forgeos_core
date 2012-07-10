# This migration comes from forgeos_core (originally 20120709103846)
class UpgradeAttachmentsToCarrierwave < ActiveRecord::Migration
  def change
    remove_column :forgeos_attachments, :thumbnail
    remove_column :forgeos_attachments, :parent_id

    rename_column :forgeos_attachments, :filename, :file
    rename_column :forgeos_attachments, :content_type, :file_content_type
    rename_column :forgeos_attachments, :width, :file_width
    rename_column :forgeos_attachments, :height, :file_height
    rename_column :forgeos_attachments, :size, :file_size

    add_column    :forgeos_attachments, :file_image_size, :string
    add_column    :forgeos_attachments, :file_processing, :boolean
    add_column    :forgeos_attachments, :file_tmp, :string
  end
end
