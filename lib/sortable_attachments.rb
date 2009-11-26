module SortableAttachments
  def self.included(base)
    base.extend ClassMethods 
  end
  
  module ClassMethods
    def has_and_belongs_to_many_attachments
      has_many :attachment_links, :as => :element
      has_many :attachments, :through => :attachment_links, :class_name => 'Attachment'
      has_many :pictures, :through => :attachment_links, :class_name => 'Picture', :source => :attachment 

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
      ids.each_with_index do |id, i|
        connection.update(
          "UPDATE `attachment_links` SET `position` = \#{i} " +
          "WHERE `element_id` = \#{self.id} AND `element_type` = '\#{self.class.base_class}' AND `attachment_id` = \#{id}"
        ) if id.to_i != 0
      end unless self.id
    end
  end
end

ActiveRecord::Base.send(:include,SortableAttachments)
