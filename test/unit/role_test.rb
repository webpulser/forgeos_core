require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test "should toogle active" do
    role = Role.new
    assert_equal true, role.active?
    role.activate
    assert_equal false, role.active?
    role.activate
    assert_equal true, role.active?
  end
end
