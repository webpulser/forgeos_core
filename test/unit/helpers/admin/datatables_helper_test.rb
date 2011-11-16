require 'test_helper'

module Forgeos
  class Admin::DatatablesHelperTest < ActionView::TestCase
    include Forgeos::Admin::DatatablesHelper

    test "should init datatable" do
      output = dataTables_tag(:id => 'test', :url => '/admin', :columns => ['toto', 'tata'])
      assert_match /javascript/, output
      assert_match /dataTable\(/, output
      assert_match /jQuery\('#test'\)/, output
    end

    test "should init datatable with callback option" do
      output = dataTables_tag(:id => 'test', :url => '/admin', :columns => ['toto', 'tata'], :callback => 'callback_method')
      assert_match /'fnDrawCallback': callback_method/, output
    end

    test "should init dataslide" do
      output = dataSlides_tag(:id => 'test', :url => '/admin', :columns => ['toto', 'tata'])
      assert_match /javascript/, output
      assert_match /dataSlide\(/, output
      assert_match /jQuery\('#test'\)/, output
    end

  end
end
