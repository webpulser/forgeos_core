class Address < ActiveRecord::Base
  
  belongs_to :country

  validates_presence_of :country_id, :address, :city

  # Returns address in a string <i>#{firstname} #{name} #{address} #{zip_code} #{city}</i>
  def to_s
    "#{I18n.t civility, :scope => [:civility, :label]} #{firstname} #{name} #{address} #{zip_code} #{city} #{country.name.upcase}"
  end
  
  def kind
    read_attribute(:type)
  end
  
  def kind=(kind)
    write_attribute(:type, kind)
  end 
end
