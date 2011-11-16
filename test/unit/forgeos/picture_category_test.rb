require 'test_helper'

module Forgeos
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
      category.elements = [forgeos_attachments(:picture)]
      assert_equal [forgeos_attachments(:picture)], category.elements
    end

    test 'elements can not be other than Picture' do
      category = PictureCategory.new
      assert_raise ActiveRecord::AssociationTypeMismatch do
        category.elements = [forgeos_people(:user)]
      end
    end
  end
end
