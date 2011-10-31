require 'test_helper'

class ForgeosMenuHashTest < ActiveSupport::TestCase
  test "must be an ActiveSupport::HashWithIndifferentAccess" do
    assert_kind_of ActiveSupport::HashWithIndifferentAccess, Forgeos::MENU_HASH
  end

  test "must contain forgeos admin menu" do
    assert_not_nil Forgeos::MENU_HASH[:forgeos]
    assert_not_nil Forgeos::MENU_HASH[:forgeos][:admin]
    assert_not_nil Forgeos::MENU_HASH[:forgeos][:admin][:menu]
  end

  test "must contain forgeos admin submenu" do
    assert_not_nil Forgeos::MENU_HASH[:forgeos]
    assert_not_nil Forgeos::MENU_HASH[:forgeos][:admin]
    assert_not_nil Forgeos::MENU_HASH[:forgeos][:admin][:submenu]
  end

end
