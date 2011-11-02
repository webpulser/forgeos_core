require 'test_helper'

class PdfCategoryTest < ActiveSupport::TestCase
  test 'should inherit from Category' do
    assert_kind_of Category, PdfCategory.new
  end

  test 'should create' do
    category = PdfCategory.new
    assert category.valid?
  end

  test 'could have elements' do
    category = PdfCategory.new
    category.elements = [attachments(:pdf)]
    assert_equal [attachments(:pdf)], category.elements
  end

  test 'elements can not be other than Pdf' do
    category = PdfCategory.new
    assert_raise ActiveRecord::AssociationTypeMismatch do
      category.elements = [people(:user)]
    end
  end
end
