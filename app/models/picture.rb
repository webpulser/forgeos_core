class Picture < Attachment
  acts_as_commentable
  acts_as_taggable
  has_attachment YAML.load_file(File.join(Rails.root, 'config', 'attachments.yml'))['picture'].symbolize_keys
  validates_as_attachment
end
