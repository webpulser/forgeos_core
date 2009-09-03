class Attachment < ActiveRecord::Base
  has_many :sortable_attachments, :dependent => :destroy

  def file_type
    self.content_type.split('/')[1]
  end
end
