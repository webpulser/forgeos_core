require 'ostruct'
class Setting < ActiveRecord::Base
  belongs_to :address, :dependent => :destroy
  serialize :mailer, OpenStruct
  serialize :smtp_settings, OpenStruct
  serialize :sendmail_settings, OpenStruct
  accepts_nested_attributes_for :address

  def mailer=(mailer)
    write_attribute(:mailer, OpenStruct.new(mailer))
  end

  def smtp_settings=(smtp_settings)
    write_attribute(:smtp_settings, OpenStruct.new(smtp_settings))
  end

  def sendmail_settings=(sendmail_settings)
    write_attribute(:sendmail_settings, OpenStruct.new(sendmail_settings))
  end

  def self.current
    first
  end
end
