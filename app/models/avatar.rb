class Avatar < Attachment
  has_attachment YAML.load_file(File.join(Rails.root, 'config', 'attachments.yml'))['avatar'].symbolize_keys
  validates_as_attachment
end
