require 'test_helper'

module Forgeos
  class DocTest < ActiveSupport::TestCase
    test 'should inherit from Attachment' do
      assert_kind_of Attachment, Doc.new
    end

    test 'should retreive options from Settings' do
      settings = Doc.uploaders[:file].new
      assert_equal CarrierWave::Storage::File, settings.class.storage
      assert_equal %w(doc xls docx xlsx odt odp).sort, settings.extension_white_list.sort
    end
  end
end
