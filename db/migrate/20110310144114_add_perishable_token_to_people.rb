class AddPerishableTokenToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :perishable_token, :string, :null => :false
    User.all.map(&:reset_perishable_token!)
  end

  def self.down
    remove_column :people, :perishable_token
  end
end
