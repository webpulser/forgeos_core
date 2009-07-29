class Doc < Attachment
  has_attachment  :content_type => ['application/msword','application/vnd.oasis.opendocument.text'],
                  :file_system_path => 'public/uploads/docs',
                  :storage => :file_system,
                  :max_size => 50.megabytes
  validates_as_attachment
end
