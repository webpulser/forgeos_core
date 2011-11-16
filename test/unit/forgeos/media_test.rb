require 'test_helper'

module Forgeos
  class MediaTest < ActiveSupport::TestCase
    test 'should inherit from Attachment' do
      assert_kind_of Attachment, Media.new
    end

    test 'should retreive options from Settings' do
      assert_equal({
        :file_system_path=>"public/uploads/medias",
        :storage=>:file_system,
        :max_size=>52428800,
        :min_size=>1,
        :size=>1..52428800,
        :thumbnails=>{},
        :thumbnail_class=> Media,
        :s3_access=>:public_read,
        :cloudfront=>false,
        :path_prefix=>"public/uploads/medias",
        :processor=>"CoreImage"
      }, Media.attachment_options)
    end
  end
end
