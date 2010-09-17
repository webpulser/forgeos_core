class CreateRules < ActiveRecord::Migration
  def self.up
    create_table :rules do |t|
      t.text :conditions,
        :description,
        :variables
      t.integer :use,
        :max_use,
        :default => 0,
        :null => false
      t.string :name,
        :type,
        :code
      t.boolean :active, :default => true, :null => false
      t.belongs_to :parent
    end
  end

  def self.down
    drop_table :rules
  end
end
