class CreateRoleCategoriesRoles < ActiveRecord::Migration
  def self.up
    create_table :role_categories_roles, :id => false do |t|
      t.belongs_to :role_category, :role
    end
  end

  def self.down
    drop_table :role_categories_roles
  end
end
