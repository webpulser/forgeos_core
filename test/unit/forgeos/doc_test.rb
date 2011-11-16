require 'test_helper'

module Forgeos
  class DocTest < ActiveSupport::TestCase
    test 'should inherit from Attachment' do
      assert_kind_of Attachment, Doc.new
    end

    test 'should retreive options from Settings' do
      assert_equal({
        :content_type=> [
          "application/msword",
          "application/vnd.oasis.opendocument.text"
        ],
        :file_system_path=>"public/uploads/docs",
        :storage=>:file_system,
        :max_size=>52428800,
        :min_size=>1,
        :size=>1..52428800,
        :thumbnails=>{},
        :thumbnail_class=> Doc,
        :s3_access=>:public_read,
        :cloudfront=>false,
        :path_prefix=>"public/uploads/docs",
        :processor=>"CoreImage"
      }, Doc.attachment_options)
    end
  end
end
