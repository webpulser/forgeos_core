module SortableAttachments #:nodoc:

  def attachment_ids_with_position=(attachment_ids)
    self.attachment_ids_without_position=(attachment_ids)
    reset_attachment_positions_by_ids(attachment_ids)
  end
 
  def reset_attachment_positions_by_ids(ids)
    ids.each_with_index do |id, i|
      connection.update(
        "UPDATE `attachment_links` SET `position` = #{i} " +
        "WHERE `element_id` = #{self.id} AND `element_type` = '#{self.class.base_class}' AND `attachment_id` = #{id}"
      ) if id.to_i != 0
    end
  end

end
