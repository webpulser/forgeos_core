module Forgeos
  class Person < ActiveRecord::Base
    acts_as_authentic do |c|
      c.merge_validates_uniqueness_of_email_field_options( :if => :email_uniq? )
      c.crypto_provider = Authlogic::CryptoProviders::BCrypt
    end

    ransacker :full_name do |parent|
      case self.connection.class.to_s
      when 'ActiveRecord::ConnectionAdapters::MysqlAdapter', 'ActiveRecord::ConnectionAdapters::Mysql2Adapter'
        Arel::Nodes::NamedFunction.new 'CONCAT', [ parent.table[:firstname], parent.table[:lastname] ]
      else
        Arel::Nodes::Concatenation.new parent.table[:firstname], parent.table[:lastname]
      end
    end

    acts_as_tagger
    has_and_belongs_to_many_attachments

    has_one :avatar,
      :dependent => :destroy
    has_one :address,
      :dependent => :destroy
    accepts_nested_attributes_for :address
    accepts_nested_attributes_for :avatar, :reject_if => proc { |attributes| attributes['uploaded_data'].blank? }

    validates :lastname,
      :presence => { :if => :lastname_required? }
    validates :firstname,
      :presence => { :if => :firstname_required? }

    attr_accessible :lastname, :firstname, :email, :password, :password_confirmation,
      :civility, :country_id, :birthday, :phone, :other_phone, :email_confirmation,
      :avatar_attributes, :lang, :time_zone, :address_attributes
    attr_accessible :active, :as => :admin

    def self.generate_password(size)
      s = ""
      size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }

      s
    end

    # list of columns availables in autogenerated forms
    def self.input_columns
      content_columns.map(&:name).map(&:to_sym) -
      [ :crypted_password, :password_salt, :persistence_token,
        :last_request_at, :current_login_at, :last_login_at,
        :current_login_ip, :last_login_ip, :perishable_token,
        :created_at, :updated_at
      ]
    end

    # Activates the user in the database.
    def activate
      self.active = true
    end

    def activate!
      activate

      save
    end

    # Disactivates the user in the database.
    def disactivate
      self.active = false
    end

    def disactivate!
      disactivate

      save
    end


    def full_name
      "#{firstname} #{lastname}"
    end
    alias :to_s :full_name


  protected

    def email_uniq?
      true
    end

    def lastname_required?
      true
    end

    def firstname_required?
      true
    end
  end
end
