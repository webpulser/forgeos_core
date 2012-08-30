class AddBackgroundUploadsToForgeosSettings < ActiveRecord::Migration
  def change
    add_column :forgeos_settings, :background_uploads, :boolean, :null => false, :default => false
  end
end
