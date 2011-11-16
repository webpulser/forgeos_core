require 'test_helper'

module Forgeos
  class VideoCategoryTest < ActiveSupport::TestCase
    test 'should inherit from Category' do
      assert_kind_of Category, VideoCategory.new
    end

    test 'should create' do
      category = VideoCategory.new
      assert category.valid?
    end

    test 'could have elements' do
      category = VideoCategory.new
      category.elements = [forgeos_attachments(:video)]
      assert_equal [forgeos_attachments(:video)], category.elements
    end

    test 'elements can not be other than Video' do
      category = VideoCategory.new
      assert_raise ActiveRecord::AssociationTypeMismatch do
        category.elements = [forgeos_people(:user)]
      end
    end
  end
end
