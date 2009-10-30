class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :name,
        :lang,
        :phone_number,
        :fax_number,
        :email
      t.text :mailer
      t.belongs_to :address
    end
  end

  def self.down
    drop_table :settings
  end
end
