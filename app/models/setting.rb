require 'ostruct'
class Setting < ActiveRecord::Base
  belongs_to :address, :dependent => :destroy
  serialize :mailer
  serialize :smtp_settings
  serialize :sendmail_settings
  serialize :attachments
  accepts_nested_attributes_for :address

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

  def smtp_settings_attributes=(attributes)
    if attributes and attributes[:authentication] == 'none'
      [:authentication, :password, :user_name].each do |key|
        attributes.delete(key)
      end
    end

    write_attribute(:smtp_settings, attributes)
  end

  def mailer_attributes=(attributes)
    write_attribute(:mailer, attributes)
  end

  def sendmail_settings_attributes=(attributes)
    write_attribute(:sendmail_settings, attributes)
  end
end
