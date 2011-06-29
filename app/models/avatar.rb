class Avatar < Attachment
  has_attachment self.options_for('avatar')
  validates_as_attachment
end
