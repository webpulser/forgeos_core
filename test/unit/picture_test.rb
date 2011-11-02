require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  test 'should inherit from Attachment' do
    assert_kind_of Attachment, Picture.new
  end

  test 'should retreive options from Settings' do
    assert_equal({
      :storage=>:file_system,
      :file_system_path=>"public/uploads/images",
      :content_type=> [
        "image/jpeg",
        "image/pjpeg",
        "image/jpg",
        "image/gif",
        "image/png",
        "image/x-png",
        "image/jpg",
        "image/x-ms-bmp",
        "image/bmp",
        "image/x-bmp",
        "image/x-bitmap",
        "image/x-xbitmap",
        "image/x-win-bitmap",
        "image/x-windows-bmp",
        "image/ms-bmp",
        "application/bmp",
        "application/x-bmp",
        "application/x-win-bitmap",
        "application/preview",
        "image/jp_",
        "application/jpg",
        "application/x-jpg",
        "image/pipeg",
        "image/vnd.swiftview-jpeg",
        "image/x-xbitmap",
        "application/png",
        "application/x-png",
        "image/gi_",
        "image/x-citrix-pjpeg"
      ],
      :thumbnails=> {
        :big => "500x500",
        :normal => "200x200",
        :small => "100x100",
        :thumb => "50x50",
        :categories_icon => "16x16"
      },
      :max_size=>52428800,
      :min_size=>1,
      :size=>1..52428800,
      :thumbnail_class=> Picture,
      :s3_access=>:public_read,
      :cloudfront=>false,
      :path_prefix=>"public/uploads/images",
      :processor=>"CoreImage"
    }, Picture.attachment_options)
  end
end
