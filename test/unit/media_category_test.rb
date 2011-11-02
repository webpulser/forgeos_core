require 'test_helper'

class MediaCategoryTest < ActiveSupport::TestCase
  test 'should inherit from Category' do
    assert_kind_of Category, MediaCategory.new
  end

  test 'should create' do
    category = MediaCategory.new
    assert category.valid?
  end

  test 'could have elements' do
    category = MediaCategory.new
    category.elements = [attachments(:media)]
    assert_equal [attachments(:media)], category.elements
  end

  test 'elements can not be other than Media' do
    category = MediaCategory.new
    assert_raise ActiveRecord::AssociationTypeMismatch do
      category.elements = [people(:user)]
    end
  end
end
