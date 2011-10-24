class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :address,
        :address_2,
        :zip_code,
        :city,
        :type
      t.belongs_to :country,
        :person
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
