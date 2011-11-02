require 'test_helper'

class RoleCategoryTest < ActiveSupport::TestCase
  test 'should create' do
    category = RoleCategory.new
    assert category.valid?
  end

  test 'could have elements' do
    category = RoleCategory.new
    category.elements = [roles(:role)]
    assert_equal [roles(:role)], category.elements
  end

  test 'elements can not be other than Role' do
    category = RoleCategory.new
    assert_raise ActiveRecord::AssociationTypeMismatch do
      category.elements = [people(:user)]
    end
  end
end
