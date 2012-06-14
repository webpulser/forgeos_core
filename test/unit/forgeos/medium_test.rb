require 'test_helper'

module Forgeos
  class MediumTest < ActiveSupport::TestCase
    test 'should inherit from Attachment' do
      assert_kind_of Attachment, Medium.new
    end

    test 'should retreive options from Settings' do
      assert_equal({
        :file_system_path=>"public/uploads/media",
        :storage=>:file_system,
        :max_size=>52428800,
        :min_size=>1,
        :size=>1..52428800,
        :thumbnails=>{},
        :thumbnail_class=> Medium,
        :s3_access=>:public_read,
        :cloudfront=>false,
        :path_prefix=>"public/uploads/media",
        :processor=>"CoreImage"
      }, Medium.attachment_options)
    end
  end
end
