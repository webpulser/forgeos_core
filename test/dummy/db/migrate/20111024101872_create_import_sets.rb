class CreateImportSets < ActiveRecord::Migration
  def self.up
    create_table :import_sets do |t|
      t.text :fields, :parser_options
      t.boolean :ignore_first_row, :default => true, :null => false
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :import_sets
  end
end
