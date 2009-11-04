class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :name,
        :lang,
        :time_zone,
        :phone_number,
        :fax_number,
        :email
      t.text :mailer,
        :smtp_settings,
        :sendmail_settings
      t.belongs_to :address
    end
  end

  def self.down
    drop_table :settings
  end
end
