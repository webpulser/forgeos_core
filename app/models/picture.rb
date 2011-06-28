class Picture < Attachment
  has_attachment self.options_for('picture')
  validates_as_attachment
end
