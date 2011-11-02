require 'test_helper'

class AdministratorCategoryTest < ActiveSupport::TestCase
  test 'should inherit from Category' do
    assert_kind_of Category, AdministratorCategory.new
  end

  test 'should create' do
    category = AdministratorCategory.new
    assert category.valid?
  end

  test 'could have elements' do
    category = AdministratorCategory.new
    category.elements = [people(:administrator)]
    assert_equal [people(:administrator)], category.elements
  end

  test 'elements can not be other than Administrator' do
    category = AdministratorCategory.new
    assert_raise ActiveRecord::AssociationTypeMismatch do
      category.elements = [people(:user)]
    end
  end
end
