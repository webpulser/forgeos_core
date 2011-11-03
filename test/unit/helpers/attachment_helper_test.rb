require 'test_helper'

class AttachmentHelperTest < ActionView::TestCase
  include Forgeos::AttachmentHelper

  test "should retrieve attachment class from content_type" do
    media = OpenStruct.new(:content_type => 'image/jpeg')
    assert_equal Picture, attachment_class_from_content_type(media)
  end

  test "should retrieve attachment class name from content_type" do
    media = OpenStruct.new(:content_type => 'image/jpeg')
    assert_equal 'picture', find_media_type_from_content_type(media)
  end

  test "should retrieve attachment categories from content_type" do
    media = OpenStruct.new(:content_type => 'image/jpeg')
    categories = []
    5.times do |i|
      categories << PictureCategory.create(:name => "picture category #{i}")
    end
    assert_equal categories, find_categories_from_content_type(media)
  end
end
