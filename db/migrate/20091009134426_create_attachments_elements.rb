class CreateAttachmentsElements < ActiveRecord::Migration
  def self.up
    create_table :forgeos_attachments_elements, :id => false do |t|
      t.belongs_to :attachment,
        :element
      t.integer :position
    end
  end

  def self.down
    drop_table :forgeos_attachments_elements
  end
end
