class UpdatePeople < ActiveRecord::Migration
  def self.up
		add_column :people, :civility_id, :integer
		add_column :people, :country_id, :integer
  end

  def self.down
		remove_column :people, :civility_id, :integer
		remove_column :people, :country_id, :integer
  end
end
