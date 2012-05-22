require 'test_helper'

module Forgeos
  class Admin::AccountsControllerTest < ActionController::TestCase
    setup :activate_authlogic

    test "should get index" do
      admin_login_to('admin/accounts', 'index')
      get :index, :use_route => :forgeos_core
      assert_redirected_to '/admin/account'
    end

    test "should get show" do
      admin_login_to('admin/accounts', 'show')
      get :show, :use_route => :forgeos_core
      assert_equal forgeos_people(:administrator), assigns(:user)
    end

    test "should get edit" do
      admin_login_to('admin/accounts', 'edit')
      get :edit, :use_route => :forgeos_core
      assert_equal forgeos_people(:administrator), assigns(:user)
    end

    test "should put update" do
      admin_login_to('admin/accounts', 'update')
      put :update, :use_route => :forgeos_core, :administrator => { :lastname => 'toto', :lang => 'en' }
      assert_equal forgeos_people(:administrator), assigns(:user)
      assert_equal 'toto', forgeos_people(:administrator).reload.lastname
      assert_equal 'en', forgeos_people(:administrator).reload.lang
    end

    test "should not update" do
      admin_login_to('admin/accounts', 'update')
      put :update, :use_route => :forgeos_core, :administrator => { :lastname => nil }
      assert_equal forgeos_people(:administrator), assigns(:user)
      assert !assigns(:user).valid?
    end
  end
end
