class Doc < Attachment
  has_attachment YAML.load_file(File.join(Rails.root, 'config', 'attachments.yml'))['doc'].symbolize_keys
  validates_as_attachment
end
