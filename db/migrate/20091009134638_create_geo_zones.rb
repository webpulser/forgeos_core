class CreateGeoZones < ActiveRecord::Migration
  def self.up
    create_table :forgeos_geo_zones do |t|
      t.string :iso,
        :iso3,
        :name,
        :printable_name,
        :type
      t.integer :numcode
      t.belongs_to :parent
    end
  end

  def self.down
    drop_table :forgeos_geo_zones
  end
end
