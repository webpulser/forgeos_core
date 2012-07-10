module Forgeos
  module AttachmentHelper
    def attachment_class_from_extension(extension)
      Attachment.detect_attachment_class_from_extension(extension)
    end

    def find_categories_from_extension(extension)
      "#{attachment_class_from_extension(extension)}Category".constantize.roots
    end

    def find_media_type_from_extension(extension)
      attachment_class_from_extension(extension).to_s.underscore
    end
  end
end
