class Picture < Attachment

  acts_as_commentable
  acts_as_taggable
  has_attachment YAML.load_file(File.join(RAILS_ROOT, 'config', 'sortable_pictures.yml')).symbolize_keys
  validates_presence_of :content_type

  has_many :sortable_pictures, :dependent => :destroy
end
