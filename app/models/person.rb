class Person < ActiveRecord::Base
  acts_as_authentic do |c|
    c.transition_from_restful_authentication = true
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  acts_as_tagger

  has_one :avatar, :dependent => :destroy
  accepts_nested_attributes_for :avatar
  
  validates_presence_of     :lastname, :firstname, :email
  #validates_length_of       :email,    :within => 3..100, :too_long => "is too long", :too_short => "is too short"
  validates_uniqueness_of   :email, :case_sensitive => false, :message => "is invalid"
  #validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :lastname, :firstname, :email, :password, :password_confirmation,
    :civility, :country_id, :birthday, :phone, :other_phone, :email_confirmation,
    :avatar_attributes, :lang, :time_zone

  define_index do
    indexes firstname, :sortable => true
    indexes lastname, :sortable => true
    indexes email, :sortable => true
  end

  def fullname
    "#{lastname} #{firstname}"
  end
end
