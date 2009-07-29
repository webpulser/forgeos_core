class Media < Attachment
  has_attachment YAML.load_file(File.join(RAILS_ROOT, 'config', 'attachments.yml'))['media'].symbolize_keys
  validates_as_attachment
end
