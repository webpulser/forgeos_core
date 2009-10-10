class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :name,
        :firstname,
        :address,
        :address_2,
        :zip_code,
        :city,
        :type,
        :designation
      t.integer :civility
      t.belongs_to :country,
        :user,
        :order
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
