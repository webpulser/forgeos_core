class CreateAttachmentsAll < ActiveRecord::Migration
  def self.up
    create_table :attachments_products, :id => false do |t|
      t.belongs_to :attachment, :product
      t.integer :position
    end
    create_table :attachments_categories, :id => false do |t|
      t.belongs_to :attachment, :category
      t.integer :position
    end
    create_table :attachments_shipping_methods, :id => false do |t|
      t.belongs_to :attachment, :shipping_method
      t.integer :position
    end
    create_table :attachments_product_types, :id => false do |t|
      t.belongs_to :attachment, :product_type
      t.integer :position
    end
    create_table :attachments_users, :id => false do |t|
      t.belongs_to :attachment, :user
      t.integer :position
    end
    create_table :attachments_tattributes, :id => false do |t|
      t.belongs_to :attachment, :tattribute
      t.integer :position
    end
    create_table :attachments_tattribute_values, :id => false do |t|
      t.belongs_to :attachment, :tattribute_value
      t.integer :position
    end
  end

  def self.down
    drop_table :attachments_products
    drop_table :attachments_categories
    drop_table :attachments_shipping_methods
    drop_table :attachments_product_types
    drop_table :attachments_users
    drop_table :attachments_tattributes
    drop_table :attachments_tattribute_values
  end
end
