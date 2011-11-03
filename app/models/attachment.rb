class Attachment < ActiveRecord::Base
  has_and_belongs_to_many :categories,
    :readonly => true,
    :join_table => 'categories_elements',
    :foreign_key => 'element_id',
    :association_foreign_key => 'category_id'
  has_many :attachment_links,
    :dependent => :destroy

  before_save :fill_blank_name_with_filename

  scope :linked_to, lambda { |element_type|
    {
      :include => :attachment_links,
      :conditions => {
        :attachment_links => {
          :element_type => element_type.to_s.classify.constantize.class_name
        }
      }
    }
  }

  def file_type
    content_type.split('/').last
  end

  def fill_blank_name_with_filename
    if name.blank? and filename
      self.name = filename.split('.').first
    end
  end

  def self.options_for(target = class_name)
    return {} unless ActiveRecord::Base.connection.tables.include?(Setting.table_name) or Setting.current
    (Setting.current.attachments[target] || {}).symbolize_keys
  end

  def self.new_from_rails_form(options = {})
    data = options[:Filedata]
    filename = options[:Filename] ||
      data.send(data.respond_to?(:original_filename) ? :original_filename : :path)

    content_type = MIME::Types.type_for(filename).first.to_s
    media_class = detect_attachment_class_from_content_type(content_type)

    media = media_class.new(options[:attachment])
    media.uploaded_data = ActiveSupport::HashWithIndifferentAccess.new(
      :tempfile => data,
      :content_type => content_type,
      :filename => filename
    )

    return media
  end

  def self.detect_attachment_class_from_content_type(content_type)
    media_class = Media

    [Audio, Video, Pdf, Doc, Picture].each do |klass|
      media_class = klass if klass.attachment_options[:content_type].include?(content_type)
    end

    return media_class
  end

  define_index do
    indexes filename, :sortable => true
    indexes content_type, :sortable => true
    indexes size, :sortable => true
  end
end
