class Pdf < Attachment
  has_attachment self.options_for('pdf')
  validates_as_attachment
end
