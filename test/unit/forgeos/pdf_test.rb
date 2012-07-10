require 'test_helper'

module Forgeos
  class PdfTest < ActiveSupport::TestCase
    test 'should inherit from Attachment' do
      assert_kind_of Attachment, Pdf.new
    end

    test 'should retreive options from Settings' do
      settings = Pdf.uploaders[:file].new
      assert_equal CarrierWave::Storage::File, settings.class.storage
      assert_equal %w(pdf), settings.extension_white_list
    end
  end
end
