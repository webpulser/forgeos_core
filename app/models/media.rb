class Media < Attachment
  has_attachment  :file_system_path => 'public/uploads/medias',
                  :storage => :file_system,
                  :max_size => 50.megabytes
  validates_as_attachment
end
