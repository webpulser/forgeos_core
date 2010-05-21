class Person < ActiveRecord::Base
  acts_as_authentic do |c|
    c.transition_from_restful_authentication = true
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  acts_as_tagger
  
  has_and_belongs_to_many_attachments
  has_one :address
  accepts_nested_attributes_for :address

  has_one :avatar, :dependent => :destroy
  accepts_nested_attributes_for :avatar, :reject_if => proc { |attributes| attributes['uploaded_data'].blank? }
  
  validates_presence_of     :lastname, :firstname, :email
  #validates_length_of       :email,    :within => 3..100, :too_long => "is too long", :too_short => "is too short"
  validates_uniqueness_of   :email, :case_sensitive => false, :message => "is invalid"
  #validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :lastname, :firstname, :email, :password, :password_confirmation,
    :civility, :country_id, :birthday, :phone, :other_phone, :email_confirmation,
    :avatar_attributes, :lang, :time_zone, :address_attributes

  define_index do
    indexes firstname, :sortable => true
    indexes lastname, :sortable => true
    indexes email, :sortable => true
    set_property :delta => true
  end

  def fullname
    "#{lastname} #{firstname}"
  end

  # Disactivates the user in the database.
  def disactivate
    self.active = false
    save(false) unless self.new_record?
  end

  # Activates the user in the database.
  def activate
    self.active = true
    save(false) unless self.new_record?
  end

  # return the user status
  def active?
    self.active
  end
end
