class Video < Attachment
  has_attachment self.options_for('video')
  validates_as_attachment
end
