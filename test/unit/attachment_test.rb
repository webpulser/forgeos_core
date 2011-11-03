require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  test "should give file_type" do
    assert_equal 'application/none', attachments(:attachment).content_type
    assert_equal 'none', attachments(:attachment).file_type
  end

  test "should fill blank name with filename" do
    attachment = Attachment.new(:filename => 'attachment.none')
    assert_respond_to attachment, :fill_blank_name_with_filename
    attachment.fill_blank_name_with_filename
    assert_equal 'attachment', attachment.name
  end

  test "should initialize from rails form" do
    attachment = Attachment.new_from_rails_form(:Filedata => File.open(File.expand_path('../../files/empty.file', __FILE__)))
    assert_kind_of Media, attachment
  end

  test "should get the filename from rails form" do
    attachment = Attachment.new_from_rails_form(:Filedata => File.open(File.expand_path('../../files/empty.file', __FILE__)), :Filename => 'toto.test')
    assert_equal 'toto.test', attachment.filename
  end

  test "should retreive the right model from content_type" do
    attachment = Attachment.new_from_rails_form(:Filedata => File.open(File.expand_path('../../files/rails.png', __FILE__)))
    assert_kind_of Picture, attachment
    assert_equal 'rails.png', attachment.filename
    assert_equal 'image/png', attachment.content_type
  end

  test "should retreive linked to models" do
    attachment = attachments(:attachment)
    AttachmentLink.create(:element => roles(:role), :attachment => attachment)
    assert_equal [attachment], Attachment.linked_to(:role)
    assert_equal [attachment], Attachment.linked_to('role')
  end

  test "should retreive linked to models with inheritance" do
    attachment = attachments(:attachment)
    AttachmentLink.create(:element => people(:user), :attachment => attachment)
    assert_kind_of User, people(:user)
    assert_equal [attachment], Attachment.linked_to(:user)
    assert_equal [attachment], Attachment.linked_to('user')
  end

end
