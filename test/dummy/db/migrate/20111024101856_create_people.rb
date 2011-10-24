class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :email,
        :firstname,
        :lastname,
        :type,
        :phone,
        :other_phone,
        :lang,
        :time_zone
      t.string :crypted_password,
        :salt,
        :remember_token,
        :activation_code,
        :limit => 40
      t.datetime :remember_token_expires_at,
        :activated_at
      t.belongs_to :avatar,
        :country,
        :role
      t.date :birthday
      t.timestamps
      t.integer :civility
    end
  end

  def self.down
    drop_table :people
  end
end
