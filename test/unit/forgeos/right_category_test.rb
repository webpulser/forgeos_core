require 'test_helper'

module Forgeos
  class RightCategoryTest < ActiveSupport::TestCase
    test 'should inherit from Category' do
      assert_kind_of Category, RightCategory.new
    end

    test 'should create' do
      category = RightCategory.new(:name => 'test')
      assert category.valid?
    end

    test 'could have elements' do
      category = RightCategory.new
      category.elements = [forgeos_rights(:right)]
      assert_equal [forgeos_rights(:right)], category.elements
    end

    test 'elements can not be other than Right' do
      category = RightCategory.new
      assert_raise ActiveRecord::AssociationTypeMismatch do
        category.elements = [forgeos_people(:user)]
      end
    end
  end
end
