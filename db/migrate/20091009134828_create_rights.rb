class CreateRights < ActiveRecord::Migration
  def self.up
    create_table :forgeos_rights do |t|
      t.string :name,
        :controller_name,
        :action_name
    end
  end

  def self.down
    drop_table :forgeos_rights
  end
end
