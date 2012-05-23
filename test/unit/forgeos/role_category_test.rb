require 'test_helper'

module Forgeos
  class RoleCategoryTest < ActiveSupport::TestCase
    test 'should inherit from Category' do
      assert_kind_of Category, RoleCategory.new
    end

    test 'should create' do
      category = RoleCategory.new(:name => 'test')
      assert category.valid?
    end

    test 'could have elements' do
      category = RoleCategory.new
      category.elements = [forgeos_roles(:role)]
      assert_equal [forgeos_roles(:role)], category.elements
    end

    test 'elements can not be other than Role' do
      category = RoleCategory.new
      assert_raise ActiveRecord::AssociationTypeMismatch do
        category.elements = [forgeos_people(:user)]
      end
    end
  end
end
