require 'test_helper'

module Forgeos
  class MediaCategoryTest < ActiveSupport::TestCase
    test 'should inherit from Category' do
      assert_kind_of Category, MediaCategory.new
    end

    test 'should create' do
      category = MediaCategory.new(:name => 'test')
      assert category.valid?
    end

    test 'could have elements' do
      category = MediaCategory.new
      category.elements = [forgeos_attachments(:media)]
      assert_equal [forgeos_attachments(:media)], category.elements
    end

    test 'elements can not be other than Media' do
      category = MediaCategory.new
      assert_raise ActiveRecord::AssociationTypeMismatch do
        category.elements = [forgeos_people(:user)]
      end
    end
  end
end
