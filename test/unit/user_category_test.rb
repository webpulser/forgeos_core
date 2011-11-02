require 'test_helper'

class UserCategoryTest < ActiveSupport::TestCase
  test 'should create' do
    category = UserCategory.new
    assert category.valid?
  end

  test 'could have elements' do
    category = UserCategory.new
    category.elements = [people(:user)]
    assert_equal [people(:user)], category.elements
  end

  test 'elements can not be other than User' do
    category = UserCategory.new
    assert_raise ActiveRecord::AssociationTypeMismatch do
      category.elements = [people(:administrator)]
    end
  end
end
