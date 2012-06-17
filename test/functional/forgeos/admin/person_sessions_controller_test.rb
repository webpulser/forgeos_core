require 'test_helper'

module Forgeos
  class Admin::PersonSessionsControllerTest < ActionController::TestCase
    setup :activate_authlogic

    test "should get new" do
      get :new, :use_route => :forgeos_core
      assert_kind_of PersonSession, assigns(:person_session)
    end

    test "should delete destroy without logged user" do
      delete :destroy, :use_route => :forgeos_core
      assert_redirected_to '/admin/login'
    end


    test "should delete destroy with logged user" do
      admin_login_to('admin/person_sessions', 'destroy')
      delete :destroy, :use_route => :forgeos_core
      assert_response :success
      assert_nil PersonSession.find
    end

    test "should post create" do
      post :create, :use_route => :forgeos_core
      assert_kind_of PersonSession, assigns(:person_session)
      assert_not_nil flash[:alert]
      assert_redirected_to '/admin'

      post :create, :person_session => { :email => forgeos_people(:administrator).email, :password => 'admin'}, :use_route => :forgeos_core
      assert_not_nil flash[:notice]
      assert_redirected_to '/admin'

      session[:return_to] = '/admin/test'
      post :create, :person_session => { :email => forgeos_people(:administrator).email, :password => 'admin'}, :use_route => :forgeos_core
      assert_redirected_to '/admin/test'
    end

    test "should reset password" do
      post :reset_password, :use_route => :forgeos_core, :email => forgeos_people(:administrator).email
      assert_redirected_to '/admin/login'
    end

    test "should not reset password" do
      post :reset_password, :use_route => :forgeos_core, :email => 'toto@forgeos.com'
      assert_redirected_to '/admin/login'
      assert_not_nil flash[:alert]
    end

    test "could not reset password" do
      forgeos_people(:administrator).update_attribute(:lastname, nil)
      assert !forgeos_people(:administrator).reload.valid?
      post :reset_password, :use_route => :forgeos_core, :email => forgeos_people(:administrator).email
      assert_redirected_to '/admin/login'
      assert_not_nil flash[:alert]
    end

  end
end
