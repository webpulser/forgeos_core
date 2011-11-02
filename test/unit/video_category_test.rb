require 'test_helper'

class VideoCategoryTest < ActiveSupport::TestCase
  test 'should create' do
    category = VideoCategory.new
    assert category.valid?
  end

  test 'could have elements' do
    category = VideoCategory.new
    category.elements = [attachments(:video)]
    assert_equal [attachments(:video)], category.elements
  end

  test 'elements can not be other than Video' do
    category = VideoCategory.new
    assert_raise ActiveRecord::AssociationTypeMismatch do
      category.elements = [people(:user)]
    end
  end
end
