class Person < ActiveRecord::Base
  acts_as_authentic do |c|
    c.merge_validates_uniqueness_of_email_field_options( :unless => :skip_uniqueness_of_email? )
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  acts_as_tagger

  has_and_belongs_to_many_attachments
  has_one :avatar,
    :dependent => :destroy
  has_one :address,
    :dependent => :destroy
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :avatar, :reject_if => proc { |attributes| attributes['uploaded_data'].blank? }

  validates_presence_of :lastname, :unless => :skip_presence_of_lastname?
  validates_presence_of :firstname, :unless => :skip_presence_of_firstname?

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :lastname, :firstname, :email, :password, :password_confirmation,
    :civility, :country_id, :birthday, :phone, :other_phone, :email_confirmation,
    :avatar_attributes, :lang, :time_zone, :address_attributes
  attr_accessible :active, :as => :admin

  def fullname
    "#{lastname} #{firstname}"
  end

  def name
    "#{firstname} #{lastname}"
  end


  # Disactivates the user in the database.
  def disactivate
    self.active = false
    save
  end

  # Activates the user in the database.
  def activate
    self.active = true
    save
  end

  protected

  def skip_uniqueness_of_email?
    false
  end

  def skip_presence_of_lastname?
    false
  end

  def skip_presence_of_firstname?
    false
  end
end
