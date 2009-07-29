class Video < Attachment
  has_attachment  :content_type => %w[video/x-msvideo video/mpeg],
                  :file_system_path => 'public/uploads/videos',
                  :storage => :file_system,
                  :max_size => 50.megabytes
  validates_as_attachment
end
