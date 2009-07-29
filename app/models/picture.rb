class Picture < Attachment
  acts_as_commentable
  acts_as_taggable
  has_attachment YAML.load_file(File.join(RAILS_ROOT, 'config', 'attachments.yml'))['picture'].symbolize_keys
  validates_as_attachment
end
