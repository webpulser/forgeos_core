require 'test_helper'

class ForgeosTest < ActiveSupport::TestCase
  test "should sanitize url" do
    assert_equal 'abcdefghijklmnopqrstu', Forgeos::url_generator('àbcdéfghîjklmnöpqrstù-[) ~#')
  end
end
