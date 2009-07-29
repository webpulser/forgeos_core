class Pdf < Attachment
  has_attachment  :content_type => 'application/pdf',
                  :file_system_path => 'public/uploads/pdfs',
                  :storage => :file_system,
                  :max_size => 50.megabytes
  validates_as_attachment
end
