require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  test 'should inherit from Attachment' do
    assert_kind_of Attachment, Video.new
  end

  test 'should retreive options from Settings' do
    assert_equal({
      :content_type=> [
        "video/x-msvideo",
        "video/mpeg",
        "video/x-flv",
        "video/quicktime"
      ],
      :file_system_path=> "public/uploads/videos",
      :storage=> :file_system,
      :max_size=> 52428800,
      :min_size=> 1,
      :size=> 1..52428800,
      :thumbnails=> {},
      :thumbnail_class => Video,
      :s3_access=> :public_read,
      :cloudfront=> false,
      :path_prefix=> "public/uploads/videos",
      :processor=> "CoreImage"
    }, Video.attachment_options)
  end
end
