class MigrateFromRestfulAuthenticationToAuthlogic < ActiveRecord::Migration
  def change
    change_table :forgeos_people do |t|
      t.rename :salt, :password_salt
      t.change :password_salt, :string, :limit => 128
      t.change :crypted_password, :string, :limit => 128
      t.string :persistence_token, :null => false, :default => ''
      t.string :people, :perishable_token, :string, :null => :false, :default => ''
      t.integer :login_count,
        :failed_login_count,
        :null => false,
        :default => 0
      t.datetime :last_request_at,
        :current_login_at,
        :last_login_at
      t.string :current_login_ip,
        :last_login_ip
      t.boolean :active, :default => false, :null => false
      t.remove :remember_token,
        :activation_code,
        :remember_token_expires_at,
        :activated_at
    end
  end
end
