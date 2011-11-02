require 'test_helper'

class AudioCategoryTest < ActiveSupport::TestCase
  test 'should inherit from Category' do
    assert_kind_of Category, AudioCategory.new
  end

  test 'should create' do
    category = AudioCategory.new
    assert category.valid?
  end

  test 'could have elements' do
    category = AudioCategory.new
    category.elements = [attachments(:audio)]
    assert_equal [attachments(:audio)], category.elements
  end

  test 'elements can not be other than Audio' do
    category = AudioCategory.new
    assert_raise ActiveRecord::AssociationTypeMismatch do
      category.elements = [people(:user)]
    end
  end
end
