class Attachment < ActiveRecord::Base
  has_many :sortable_attachments, :dependent => :destroy
  has_and_belongs_to_many   :attachment_categories, :readonly => true

  def file_type
    self.content_type.split('/')[1]
  end
end
