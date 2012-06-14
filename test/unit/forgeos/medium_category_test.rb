require 'test_helper'

module Forgeos
  class MediumCategoryTest < ActiveSupport::TestCase
    test 'should inherit from Category' do
      assert_kind_of Category, MediumCategory.new
    end

    test 'should create' do
      category = MediumCategory.new(:name => 'test')
      assert category.valid?
    end

    test 'could have elements' do
      category = MediumCategory.new
      category.elements = [forgeos_attachments(:medium)]
      assert_equal [forgeos_attachments(:medium)], category.elements
    end

    test 'elements can not be other than Medium' do
      category = MediumCategory.new
      assert_raise ActiveRecord::AssociationTypeMismatch do
        category.elements = [forgeos_people(:user)]
      end
    end
  end
end
