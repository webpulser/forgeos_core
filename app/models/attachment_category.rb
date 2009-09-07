class AttachmentCategory < Category
  has_and_belongs_to_many :attachments
  has_and_belongs_to_many :elements, :class_name => 'Attachment'
end
