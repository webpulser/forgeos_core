class MigrateFromRestfulAuthenticationToAuthlogic < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.rename :salt, :password_salt
      t.change :password_salt, :string, :limit => 128
      t.change :crypted_password, :string, :limit => 128
      t.string :persistence_token, :null => false
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

  def self.down
    change_table :people do |t|
      t.rename :password_salt,:salt
      t.change :salt, :string, :limit => 40
      t.change :crypted_password, :string, :limit => 40
      t.remove :persistence_token,
        :login_count,
        :failed_login_count,
        :last_request_at,
        :current_login_at,
        :last_login_at,
        :current_login_ip,
        :last_login_ip,
        :active
      t.string :remember_token,
        :activation_code,
        :limit => 40
      t.datetime :remember_token_expires_at,
        :activated_at
    end

  end
end
