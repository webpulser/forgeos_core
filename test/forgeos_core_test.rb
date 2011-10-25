require 'test_helper'

class ForgeosCoreTest < ActiveSupport::TestCase
  setup do
    @engine = Rails.application.railties.engines.find do |engine|
      engine.engine_name == 'forgeos_core_engine'
    end
  end

  test "is an engine" do
    assert_kind_of Rails::Engine, @engine
  end

  test "have forgeos_admin_menu_path" do
    assert_not_nil @engine.paths['forgeos_admin_menu']
  end

  test "could initialize menu" do
    assert_kind_of HashWithIndifferentAccess, Forgeos::MENU_HASH
  end

  test "could initialize admin menu" do
    assert_not_nil Forgeos::MENU_HASH[:forgeos][:admin][:menu]
  end

  test "could initialize admin submenu" do
    assert_not_nil Forgeos::MENU_HASH[:forgeos][:admin][:submenu]
  end

  test "could merge menu" do
    @engine.paths['forgeos_admin_menu'] << 'test/files/admin_menu.yml'
    load File.expand_path('../../config/initializers/forgeos_menu_hash.rb', __FILE__)
    assert Forgeos::MENU_HASH.has_key?('new_entry'), 'The forgeos menu hash hasn\'t been merged'
  end

  test "could merge menu with the application" do
    Rails.application.paths['forgeos_admin_menu'] = 'config/forgeos_admin_menu.yml'
    load File.expand_path('../../config/initializers/forgeos_menu_hash.rb', __FILE__)
    assert Forgeos::MENU_HASH.has_key?('new_entry'), 'The forgeos menu hash hasn\'t been merged'
    assert_equal 'application', Forgeos::MENU_HASH[:new_entry]
  end

end
