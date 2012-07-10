require 'test_helper'

module Forgeos
  class SortableAttachmentsTest < ActiveSupport::TestCase
    class Forgeos::SortableAttachmentRecord < ActiveRecord::Base
      self.table_name = 'forgeos_people'
      has_and_belongs_to_many_attachments
    end

    test "should be included in ActiveRecord::Base" do
      assert ActiveRecord::Base.respond_to?(:has_and_belongs_to_many_attachments)
    end

    test "should include instance methods" do
      record = Forgeos::SortableAttachmentRecord.new
      assert_respond_to record, :attachment_ids
      assert_respond_to record, :picture_ids
      assert_respond_to record, :doc_ids
      assert_respond_to record, :video_ids
      assert_respond_to record, :audio_ids
      assert_respond_to record, :pdf_ids
      assert_respond_to record, :medium_ids
      assert_respond_to record, :attachment_ids=
      assert_respond_to record, :attachment_links
      assert_respond_to record, :attachment_ids_with_position=
      assert_respond_to record, :reset_attachment_positions_by_ids
    end

    test "should reset attachment positions with new record" do
      record = Forgeos::SortableAttachmentRecord.new
      assert_nil record.reset_attachment_positions_by_ids([])
    end

    test "should reset attachment positions" do
      record = Forgeos::SortableAttachmentRecord.create(:attachment_ids => [forgeos_attachments(:picture).id, forgeos_attachments(:audio).id])

      assert_equal [forgeos_attachments(:picture).id, forgeos_attachments(:audio).id], record.attachment_ids

      record.update_attributes(:attachment_ids => [forgeos_attachments(:audio).id, forgeos_attachments(:picture).id])
      record.attachments.reload
      assert_equal [forgeos_attachments(:audio).id, forgeos_attachments(:picture).id], record.attachment_ids
    end

    test "should get attachment by type" do
      record = Forgeos::SortableAttachmentRecord.create(:attachment_ids => [forgeos_attachments(:picture).id, forgeos_attachments(:audio).id])

      assert_equal [forgeos_attachments(:picture), forgeos_attachments(:audio)], record.attachments
      assert_equal [forgeos_attachments(:picture)], record.pictures
      assert_equal [forgeos_attachments(:audio)], record.audios
    end
  end
end
