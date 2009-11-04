require 'osrtuct'
class Setting < ActiveRecord::Base
  belongs_to :address
  serialize :mailer, OpenStruct
  accepts_nested_attributes_for :address

  #def after_initialize
  #  self.mailer ||= OpenStruct.new
  #end

  #def mailer=(mailer)
  #  write_attribute(:mailer, OpenStruct.new(mailer))
  #end
end
