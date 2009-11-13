class AttachmentLink < ActiveRecord::Base
  belongs_to :attachment, :polymorphic => true
  belongs_to :element, :polymorphic => true
  #YAML.load_file(File.join(RAILS_ROOT, 'config', 'attachments.yml')).symbolize_keys.keys
  acts_as_double_polymorphic_join(
    :attachments => [:pictures, :docs, :pdfs, :medias, :videos],
    :elements => Forgeos::HasSortableAttachments,
    :order => '`attachment_links`.`position`'
  )
end
