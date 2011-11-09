require 'test_helper'

class Admin::BaseControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "should change Globalize locale" do
    assert_equal :en, Globalize.locale
    get :edition_locale_test, nil, { :lang => :fr }
    assert_response :success
    assert_equal :fr, Globalize.locale
  end

  test "should request login" do
    get :login_required_test
    assert_response :redirect
  end

  test "should redirect non Administrator users" do
    PersonSession.create(people(:user))
    get :login_required_test
    assert_redirected_to '/admin/login'
  end

  test "should redirect unauthorized administrator" do
    PersonSession.create(people(:administrator))
    get :login_required_test
    assert_redirected_to '/admin/login'
  end

  test "should redirect unauthorized administrator with dashboard authorizations" do
    admin_login_to('admin/dashboard', 'index')
    get :login_required_test
    assert_redirected_to '/admin'
  end

  test "should grant access to authorized administrator" do
    admin_login_to('admin/base', 'login_required_test')
    get :login_required_test
    assert_response :success
  end

end
