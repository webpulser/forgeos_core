require 'test_helper'

module Forgeos
  class PictureTest < ActiveSupport::TestCase
    test 'should inherit from Attachment' do
      assert_kind_of Attachment, Picture.new
    end

    test 'should retreive options from Settings' do
      settings = Picture.uploaders[:file].new
      assert_equal CarrierWave::Storage::File, settings.class.storage
      assert_equal %w(jpeg jpg gif png), settings.extension_white_list
    end
  end
end
