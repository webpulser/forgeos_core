require 'test_helper'

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
    category.elements = [attachments(:doc)]
    assert_equal [attachments(:doc)], category.elements
  end

  test 'elements can not be other than Doc' do
    category = DocCategory.new
    assert_raise ActiveRecord::AssociationTypeMismatch do
      category.elements = [people(:user)]
    end
  end
end
