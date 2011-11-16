require 'test_helper'

module Forgeos
  class AudioTest < ActiveSupport::TestCase
    test 'should inherit from Attachment' do
      assert_kind_of Attachment, Audio.new
    end

    test 'should retreive options from Settings' do
      assert_equal({
        :content_type=> [
          "audio/mpeg",
          "audio/x-wav",
          "audio/ogg",
          "application/ogg"
        ],
        :file_system_path=>"public/uploads/audio",
        :storage=>:file_system,
        :max_size=>52428800,
        :min_size=>1,
        :size=>1..52428800,
        :thumbnails=>{},
        :thumbnail_class=> Audio,
        :s3_access=>:public_read,
        :cloudfront=>false,
        :path_prefix=>"public/uploads/audio",
        :processor=>"CoreImage"
      }, Audio.attachment_options)
    end
  end
end
