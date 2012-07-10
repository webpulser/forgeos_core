require 'test_helper'

module Forgeos
  class VideoTest < ActiveSupport::TestCase
    test 'should inherit from Attachment' do
      assert_kind_of Attachment, Video.new
    end

    test 'should retreive options from Settings' do
      settings = Video.uploaders[:file].new
      assert_equal CarrierWave::Storage::File, settings.class.storage
      assert_equal %w(ogg mpg avi mp4 flv mov).sort, settings.extension_white_list.sort
    end
  end
end
