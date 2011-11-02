require 'test_helper'

class PictureCategoryTest < ActiveSupport::TestCase
  test 'should inherit from Category' do
    assert_kind_of Category, PictureCategory.new
  end

  test 'should create' do
    category = PictureCategory.new
    assert category.valid?
  end

  test 'could have elements' do
    category = PictureCategory.new
    category.elements = [attachments(:picture)]
    assert_equal [attachments(:picture)], category.elements
  end

  test 'elements can not be other than Picture' do
    category = PictureCategory.new
    assert_raise ActiveRecord::AssociationTypeMismatch do
      category.elements = [people(:user)]
    end
  end
end
