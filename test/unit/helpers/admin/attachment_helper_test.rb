require 'test_helper'

module Forgeos
  class Admin::AttachmentHelperTest < ActionView::TestCase
    include Forgeos::Admin::AttachmentHelper

    test "should generate image fields" do
      output = display_visual(:toto, forgeos_attachments(:picture))
      # ensure form field is present
      assert_match /<input[^>]*type="hidden"/, output
      assert_match /<input[^>]*name="toto\[picture_id\]"/, output
      # ensure picture thumb is displayed
      assert_match /<ul class="sortable"/, output
      assert_match /<img[^>]*src="\/uploads\//, output
    end

    test "should generate image collection fields" do
      output = display_visuals(:toto, [forgeos_attachments(:picture)])
      # ensure form field is present
      assert_match /<input[^>]*type="hidden"/, output
      assert_match /<input[^>]*name="toto\[attachment_ids\]\[\]"/, output
      # ensure picture thumb is displayed
      assert_match /<ul class="sortable"/, output
      assert_match /<img[^>]*src="\/uploads\//, output
    end

  end
end
