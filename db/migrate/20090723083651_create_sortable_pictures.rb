class CreateSortablePictures < ActiveRecord::Migration
  def self.up
    create_table :sortable_pictures do |t|
      t.belongs_to :picture
      t.belongs_to :picturable, :polymorphic => true
      t.integer :position
    end
  end

  def self.down
    drop_table :sortable_pictures
  end
end
