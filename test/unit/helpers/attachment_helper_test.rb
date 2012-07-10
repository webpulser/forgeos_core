require 'test_helper'

module Forgeos
  class AttachmentHelperTest < ActionView::TestCase
    include Forgeos::AttachmentHelper

    test "should retrieve attachment class from extension" do
      assert_equal Picture, attachment_class_from_extension('jpeg')
    end

    test "should retrieve attachment class name from extension" do
      assert_equal 'forgeos/picture', find_media_type_from_extension('jpeg')
    end

    test "should retrieve attachment categories from content_type" do
      categories = []
      5.times do |i|
        categories << PictureCategory.create(:name => "picture category #{i}")
      end
      assert_equal categories, find_categories_from_extension('jpeg')
    end
  end
end
