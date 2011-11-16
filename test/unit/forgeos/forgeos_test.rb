# coding: utf-8
require 'test_helper'

module Forgeos
  class ForgeosTest < ActiveSupport::TestCase
    test "should sanitize url" do
      assert_equal 'abcdefghijklmnopqrstu', Forgeos::url_generator('àbcdéfghîjklmnöpqrstù-[) ~#')
    end
  end
end
