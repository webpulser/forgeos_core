require 'test_helper'

class AttachmentCategoryTest < ActiveSupport::TestCase
  test 'should inherit from Category' do
    assert_kind_of Category, AttachmentCategory.new
  end

  test 'should create' do
    category = AttachmentCategory.new
    assert category.valid?
  end

  test 'could have elements' do
    category = AttachmentCategory.new
    category.elements = [attachments(:attachment)]
    assert_equal [attachments(:attachment)], category.elements
  end

  test 'elements can not be other than Attachment' do
    category = AttachmentCategory.new
    assert_raise ActiveRecord::AssociationTypeMismatch do
      category.elements = [people(:user)]
    end
  end
end
