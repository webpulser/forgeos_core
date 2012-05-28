module Forgeos
  class Attachment < ActiveRecord::Base
    has_and_belongs_to_many :categories,
      :readonly => true,
      :join_table => 'forgeos_categories_elements',
      :foreign_key => 'element_id',
      :association_foreign_key => 'category_id'
    has_many :attachment_links,
      :dependent => :destroy

    before_save :fill_blank_name_with_filename
    before_update do
      self.attachment_options[:content_type].include?(content_type)
    end

    scope :linked_to, lambda { |element_type|
      {
        :include => :attachment_links,
        :conditions => {
          :forgeos_attachment_links => {
            :element_type => element_type.to_s.classify.constantize.base_class.to_s
          }
        }
      }
    }

    def file_type
      content_type.split('/').last
    end

    def self.options_for(target = class_name)
      return {} if !ActiveRecord::Base.connection.tables.include?(Setting.table_name) or
        Setting.current.nil? or
        Setting.current.attachments.nil?
      (Setting.current.attachments[target] || {}).symbolize_keys
    end

    def self.new_from_rails_form(options = {})
      if data = options[:Filedata]
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

        media
      else
        Media.new
      end
    end

    def self.detect_attachment_class_from_content_type(content_type)
      media_class = Media

      [Audio, Video, Pdf, Doc, Picture].each do |klass|
        media_class = klass if klass.attachment_options[:content_type].include?(content_type)
      end

      media_class
    end

    private

    def fill_blank_name_with_filename
      if name.blank? and filename
        self.name = filename.split('.').first
      end
    end
  end
end
