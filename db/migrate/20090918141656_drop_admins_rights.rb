class DropAdminsRights < ActiveRecord::Migration
  def self.up
    drop_table :admins_rights
  end

  def self.down
    create_table :admins_rights do |t|
      t.beloongs_to :admins, :right
    end
  end
end
