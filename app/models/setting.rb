require 'ostruct'
class Setting < ActiveRecord::Base
  belongs_to :address, :dependent => :destroy
  serialize :mailer
  serialize :smtp_settings
  serialize :sendmail_settings
  serialize :attachments
  accepts_nested_attributes_for :address

  def self.current
    first
  end

  def smtp_settings
    settings = super || {}
    settings.update(:enable_starttls_auto => (settings[:enable_starttls_auto] == '1'))
  end

end
