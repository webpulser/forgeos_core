module Forgeos
  module AttachmentHelper
    def attachment_class_from_content_type(media)
      Attachment.detect_attachment_class_from_content_type(media.content_type)
    end

    def find_categories_from_content_type(media)
      "#{attachment_class_from_content_type(media)}Category".constantize.find_all_by_parent_id(nil)
    end

    def find_media_type_from_content_type(media)
      attachment_class_from_content_type(media).to_s.underscore
    end
  end
end
