require 'test_helper'

module Forgeos
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
      category.elements = [forgeos_attachments(:audio)]
      assert_equal [forgeos_attachments(:audio)], category.elements
    end

    test 'elements can not be other than Audio' do
      category = AudioCategory.new
      assert_raise ActiveRecord::AssociationTypeMismatch do
        category.elements = [forgeos_people(:user)]
      end
    end
  end
end
