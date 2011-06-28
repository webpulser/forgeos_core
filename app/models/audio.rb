class Audio < Attachment
  has_attachment self.options_for('audio')
  validates_as_attachment
end
