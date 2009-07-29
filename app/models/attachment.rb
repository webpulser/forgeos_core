class Attachment < ActiveRecord::Base
  has_many :sortable_attachments, :dependent => :destroy
end
