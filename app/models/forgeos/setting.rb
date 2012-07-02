module Forgeos
  class Setting < ActiveRecord::Base
    belongs_to :site_address, :dependent => :destroy, :class_name => 'Forgeos::Address', :foreign_key => :address_id

    store :mailer, :accessors => [:delivery_method]
    store :smtp_settings, :accessors => [:address, :port, :domain, :enable_starttls_auto, :authentication, :user_name, :password]
    store :sendmail_settings, :accessors => [:location, :arguments]
    serialize :attachments

    accepts_nested_attributes_for :site_address

    validates :name, :presence => true

    def self.current
      first
    end

    def smtp_settings
      settings = read_attribute(:smtp_settings)
      settings = {} unless settings.is_a?(Hash)
      settings.update(:enable_starttls_auto => (settings[:enable_starttls_auto] == '1')) if settings.has_key?(:enable_starttls_auto)
      settings
    end

    def smtp_settings=(attributes)
      if attributes and attributes[:authentication] == 'none'
        [:authentication, :password, :user_name].each do |key|
          attributes.delete(key)
        end
      end

      write_attribute(:smtp_settings, attributes)
    end
  end
end
