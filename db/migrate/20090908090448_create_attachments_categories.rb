class CreateAttachmentsCategories < ActiveRecord::Migration
  def self.up
    create_table :attachments_categories, :id => false do |t|
      t.belongs_to :attachment, :category
      t.integer :position
    end
  end

  def self.down
    drop_table :attachments_categories
  end
end
