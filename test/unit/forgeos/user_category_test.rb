require 'test_helper'

module Forgeos
  class UserCategoryTest < ActiveSupport::TestCase
    test 'should inherit from Category' do
      assert_kind_of Category, UserCategory.new
    end

    test 'should create' do
      category = UserCategory.new(:name => 'test')
      assert category.valid?
    end

    test 'could have elements' do
      category = UserCategory.new
      category.elements = [forgeos_people(:user)]
      assert_equal [forgeos_people(:user)], category.elements
    end

    test 'elements can not be other than User' do
      category = UserCategory.new
      assert_raise ActiveRecord::AssociationTypeMismatch do
        category.elements = [forgeos_people(:administrator)]
      end
    end
  end
end
