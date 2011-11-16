require 'test_helper'

module Forgeos
  class DocCategoryTest < ActiveSupport::TestCase
    test 'should inherit from Category' do
      assert_kind_of Category, DocCategory.new
    end

    test 'should create' do
      category = DocCategory.new
      assert category.valid?
    end

    test 'could have elements' do
      category = DocCategory.new
      category.elements = [forgeos_attachments(:doc)]
      assert_equal [forgeos_attachments(:doc)], category.elements
    end

    test 'elements can not be other than Doc' do
      category = DocCategory.new
      assert_raise ActiveRecord::AssociationTypeMismatch do
        category.elements = [forgeos_people(:user)]
      end
    end
  end
end
