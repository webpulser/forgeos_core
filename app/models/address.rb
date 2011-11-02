class Address < ActiveRecord::Base
  belongs_to :country
  belongs_to :person
  serialize :form_attributes

  validates :country_id, :address, :city,
    :presence => true

  def to_s
    "#{address} #{address_2}, #{zip_code} #{city}, #{country.name.upcase}"
  end

  def kind
    read_attribute(:type)
  end

  def kind=(kind)
    write_attribute(:type, kind)
  end
end
