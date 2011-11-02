require 'test_helper'

class RightCategoryTest < ActiveSupport::TestCase
  test 'should inherit from Category' do
    assert_kind_of Category, RightCategory.new
  end

  test 'should create' do
    category = RightCategory.new
    assert category.valid?
  end

  test 'could have elements' do
    category = RightCategory.new
    category.elements = [rights(:right)]
    assert_equal [rights(:right)], category.elements
  end

  test 'elements can not be other than Right' do
    category = RightCategory.new
    assert_raise ActiveRecord::AssociationTypeMismatch do
      category.elements = [people(:user)]
    end
  end
end
