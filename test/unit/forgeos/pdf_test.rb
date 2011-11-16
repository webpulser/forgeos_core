require 'test_helper'

module Forgeos
  class PdfTest < ActiveSupport::TestCase
    test 'should inherit from Attachment' do
      assert_kind_of Attachment, Pdf.new
    end

    test 'should retreive options from Settings' do
      assert_equal({
        :content_type=>["application/pdf"],
        :file_system_path=>"public/uploads/pdfs",
        :storage=>:file_system,
        :max_size=>52428800,
        :min_size=>1,
        :size=>1..52428800,
        :thumbnails=>{},
        :thumbnail_class=> Pdf,
        :s3_access=>:public_read,
        :cloudfront=>false,
        :path_prefix=>"public/uploads/pdfs",
        :processor=>"CoreImage"
      }, Pdf.attachment_options)
    end
  end
end
