module Forgeos
  class Attachment < ActiveRecord::Base
    if Setting.current.background_uploads?
      require 'carrierwave_backgrounder'
      extend ::CarrierWave::Backgrounder::ORM::ActiveRecord
    end

    has_and_belongs_to_many :categories,
      :readonly => true,
      :join_table => 'forgeos_categories_elements',
      :foreign_key => 'element_id',
      :association_foreign_key => 'category_id'
    has_many :attachment_links,
      :dependent => :destroy

    before_validation :fill_blank_name_with_filename
    validates :name, :presence => true
    delegate :filename, :content_type, :width, :height, :to => :file


    scope :linked_to, lambda { |element_type|
      includes(:attachment_links).
      where(:forgeos_attachment_links => {
        :element_type => element_type.to_s.classify.constantize.base_class.to_s
      })
     }

    def self.detect_attachment_class_from_extension(extension)
      attachment_class = Medium

      [Audio, Video, Pdf, Doc, Picture].each do |klass|
        attachment_class = klass if klass.uploaders[:file].new.extension_white_list.include?(extension)
      end
      attachment_class
    end

    def self.detect_attachment_class_from_filename(filename = '')
      detect_attachment_class_from_extension(File.extname(filename).gsub('.', ''))
    end

    # Retrieve options from Forgeos::Setting
    def self.options_for(target = class_name)
      return {} if !ActiveRecord::Base.connection.tables.include?(Setting.table_name) or
        Setting.current.nil? or
        Setting.current.attachments.nil?

      ActiveSupport::HashWithIndifferentAccess.new(Setting.current.attachments[target.to_s] || {})
    end

    # Abstract ClassMethod to set attachment uploader options
    # Examples:
    # class Image < Forgeos::Attachment
    #   has_attachment :image
    # end
    def self.has_attachment(options)
      options = options_for(options) unless options.is_a?(Hash)

      thumbnails = options[:versions] || []
      extensions = options[:content_types] || nil

      mount_uploader :file, AttachmentUploader do
        storage options[:storage].to_sym

        if extensions.present?
          define_method "extension_white_list" do
            return extensions
          end
        end

        thumbnails.each do |thumbnail|
          version thumbnail[0] do
            process thumbnail[1]
          end
          thumbnails.delete(thumbnail[0])
        end
      end
      if process_upload_in_background?
        process_in_background :file
        store_in_background :file
      end
    end

    def self.process_upload_in_background?
      Setting.current.background_uploads?
    end

    def self.new_from_rails_form(options = {})
      if data = options[:Filedata]
        filename = options[:Filename]
        filename ||= data.original_filename if data.respond_to?(:original_filename)
        filename ||= File.basename(data.path)

        attachment_class = detect_attachment_class_from_filename(filename)

        options[:attachment] = {}
        options[:attachment][:file] = data
        attachment = attachment_class.new(options[:attachment])
        attachment.file.filename = filename

        attachment
      else
        Medium.new
      end
    end


    def file_type
      return '' unless file_content_type

      file_content_type.split('/').last
    end


    # AttachmentFu compatibility to attachment url with thumbnails/version as option
    # Examples:
    # public_filename => "/uploads/image.jpg"
    # public_filename(:version) => "/uploads/image_version.jpg"
    def public_filename(thumb = nil)
      if thumb.present?
        file.send(thumb).url
      else
        file.url
      end
    end

  private

    def fill_blank_name_with_filename
      filename = file.filename.to_s
      if name.blank? and filename.match(/\./)
        self.name = filename.split('.').first
      end
    end
  end
end

