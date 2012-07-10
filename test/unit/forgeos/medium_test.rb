require 'test_helper'

module Forgeos
  class MediumTest < ActiveSupport::TestCase
    test 'should inherit from Attachment' do
      assert_kind_of Attachment, Medium.new
    end

    test 'should retreive options from Settings' do
      settings = Medium.uploaders[:file].new
      assert_equal CarrierWave::Storage::File, settings.class.storage
      assert_equal nil, settings.extension_white_list
    end
  end
end
