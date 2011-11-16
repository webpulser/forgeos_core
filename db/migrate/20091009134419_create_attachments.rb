class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :forgeos_attachments do |t|
      t.string :content_type,
        :name,
        :filename,
        :alternative,
        :thumbnail,
        :type
      t.integer :height,
        :width,
        :size
      t.belongs_to :parent,
        :person
      t.timestamps
    end
  end

  def self.down
    drop_table :forgeos_attachments
  end
end
