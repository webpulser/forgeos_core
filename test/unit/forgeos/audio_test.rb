require 'test_helper'

module Forgeos
  class AudioTest < ActiveSupport::TestCase
    test 'should inherit from Attachment' do
      assert_kind_of Attachment, Audio.new
    end

    test 'should retreive options from Settings' do
      settings = Audio.uploaders[:file].new
      assert_equal CarrierWave::Storage::File, settings.class.storage
      assert_equal %w(mp3 wav ogg), settings.extension_white_list
    end
  end
end
