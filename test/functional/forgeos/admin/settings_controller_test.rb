require 'test_helper'

module Forgeos
  class Admin::SettingsControllerTest < ActionController::TestCase
    setup :activate_authlogic

    test "should get show" do
      admin_login_to('admin/settings', 'show')
      get :show, :use_route => :forgeos_core
      assert_redirected_to '/admin/setting/edit'
    end

    test "should get edit" do
      admin_login_to('admin/settings', 'edit')
      get :edit, :use_route => :forgeos_core
      assert_response :success
      assert_equal Setting.current, assigns(:setting)
    end

    test "should put update" do
      admin_login_to('admin/settings', 'update')
      put :update, :setting => { :smtp_settings => { :password => 'test'}, :name => 'test'}, :use_route => :forgeos_core
      assert_redirected_to '/admin/setting/edit'
      assert_equal Setting.current, assigns(:setting)
      assert_equal 'test', Setting.current.name
      assert_equal({ "password" => 'test' }, Setting.current.smtp_settings)
    end

    test "should not put update" do
      admin_login_to('admin/settings', 'update')
      put :update, :setting => { :name => ''}, :use_route => :forgeos_core
      assert_response :success
      assert_not_nil flash[:alert]
    end

  end
end
