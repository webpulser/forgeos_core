require 'test_helper'

module Forgeos
  class Admin::DatatablesHelperTest < ActionView::TestCase
    include Forgeos::Admin::DatatablesHelper

    test "should init datatable" do
      output = datatable(:id => 'test', :url => '/admin', :columns => ['toto', 'tata'])
      assert_match /<table/, output
      assert_match /aoColumns/, output
    end

    test "should init datatable with callback option" do
      output = datatable(:id => 'test', :url => '/admin', :columns => ['toto', 'tata'], :callback => 'callback_method')
      assert_match /fnDrawCallback&quot;:&quot;callback_method/, output
    end

    test "should init dataslide" do
      output = dataslide(:id => 'test', :url => '/admin', :columns => ['toto', 'tata'])
      assert_match /<div/, output
      assert_match /dataslide/, output
      assert_match /aoColumns/, output
    end
  end
end
