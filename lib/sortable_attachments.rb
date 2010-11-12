module SortableAttachments
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def has_and_belongs_to_many_attachments(options = {})
      has_many :attachment_links, :as => :element, :order => :position
      has_many :attachments, { :through => :attachment_links, :class_name => 'Attachment', :order => :position }.merge(options)
      has_many :pictures, :through => :attachment_links, :class_name => 'Picture', :source => :attachment, :order => :position
      has_many :docs, :through => :attachment_links, :class_name => 'Doc', :source => :attachment, :order => :position
      has_many :videos, :through => :attachment_links, :class_name => 'Video', :source => :attachment, :order => :position
      has_many :pdfs, :through => :attachment_links, :class_name => 'Pdf', :source => :attachment, :order => :position
      has_many :audios, :through => :attachment_links, :class_name => 'Audio', :source => :attachment, :order => :position
      has_many :medias, :through => :attachment_links, :class_name => 'Media', :source => :attachment, :order => :position

      unless self.instance_methods.include?('attachment_ids_with_position=')
        include SortableAttachments::InstanceMethods
        alias_method_chain :attachment_ids=, :position
      end
    end
  end

  module InstanceMethods
    def attachment_ids_with_position=(attachment_ids)
      self.attachment_ids_without_position=(attachment_ids)
      reset_attachment_positions_by_ids(attachment_ids)
    end

    def reset_attachment_positions_by_ids(ids)
      return if self.new_record?
      ids.each_with_index do |id, i|
        connection.update(
          "UPDATE `attachment_links` SET `position` = #{i} " +
          "WHERE `element_id` = #{self.id} AND `element_type` = '#{self.class.base_class}' AND `attachment_id` = #{id}"
        ) if id.to_i != 0
      end
    end
  end
end

ActiveRecord::Base.send(:include,SortableAttachments)
