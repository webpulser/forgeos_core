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

  test "should retrieve options from settings" do
    assert_equal({
      :storage => :file_system,
      :file_system_path => 'public/uploads/images',
      :content_type => :image,
      :thumbnails => {
        :big => '500x500',
        :normal => '200x200',
        :small => '100x100',
        :thumb => '50x50',
        :categories_icon => '16x16'
      },
      :max_size => 52428800
    }, Attachment.options_for('picture'))
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
end
