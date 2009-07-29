class Video < Attachment
  has_attachment YAML.load_file(File.join(RAILS_ROOT, 'config', 'attachments.yml'))['video'].symbolize_keys
  validates_as_attachment
end
