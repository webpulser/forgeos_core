module SortableAttachments
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def has_and_belongs_to_many_attachments(options = {})
      has_many :attachment_links, :as => :element, :order => :position
      has_many :attachments, :through => :attachment_links, :order => 'forgeos_attachment_links.position'

      %w(Picture Doc Video Pdf Audio Medium).each do |klass|
        defaults = {
          :through => :attachment_links,
          :class_name => "Forgeos::#{klass}",
          :source => :attachment,
          :order => "#{Forgeos::AttachmentLink.table_name}.position"
        }
        has_many klass.underscore.pluralize, defaults.merge(options)
      end

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
        Forgeos::AttachmentLink.update_all(
          "position = #{i} ",
          "element_id = #{self.id} AND element_type = #{connection.quote(self.class.to_s)} AND attachment_id = #{id}"
        ) if id.to_i != 0
      end
    end
  end
end

ActiveRecord::Base.send(:include,SortableAttachments)
