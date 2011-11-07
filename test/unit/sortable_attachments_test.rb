require 'test_helper'

class SortableAttachmentsTest < ActiveSupport::TestCase
  class ::SortableAttachmentRecord < ActiveRecord::Base
    set_table_name 'people'
    has_and_belongs_to_many_attachments
  end

  test "should be included in ActiveRecord::Base" do
    assert ActiveRecord::Base.respond_to?(:has_and_belongs_to_many_attachments)
  end

  test "should include instace methods" do
    record = ::SortableAttachmentRecord.new
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
    record = ::SortableAttachmentRecord.new
    assert_nil record.reset_attachment_positions_by_ids([])
  end

  test "should reset attachment positions" do
    record = ::SortableAttachmentRecord.create(:attachment_ids => [attachments(:picture).id, attachments(:audio).id])

    assert_equal [attachments(:picture).id, attachments(:audio).id], record.attachment_ids

    record.update_attributes(:attachment_ids => [attachments(:audio).id, attachments(:picture).id])
    record.attachments.reload
    assert_equal [attachments(:audio).id, attachments(:picture).id], record.attachment_ids
  end

  test "should " do
    record = ::SortableAttachmentRecord.create(:attachment_ids => [attachments(:picture).id, attachments(:audio).id])

    assert_equal [attachments(:picture), attachments(:audio)], record.attachments
    assert_equal [attachments(:picture)], record.pictures
    assert_equal [attachments(:audio)], record.audios
  end
end
