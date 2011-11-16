require 'test_helper'

module Forgeos
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
      category.elements = [forgeos_attachments(:pdf)]
      assert_equal [forgeos_attachments(:pdf)], category.elements
    end

    test 'elements can not be other than Pdf' do
      category = PdfCategory.new
      assert_raise ActiveRecord::AssociationTypeMismatch do
        category.elements = [forgeos_people(:user)]
      end
    end
  end
end
