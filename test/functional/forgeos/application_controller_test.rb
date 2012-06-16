require 'test_helper'

module Forgeos
  class ApplicationControllerTest < ActionController::TestCase

    test "should get notifications" do
      get :notifications, :use_route => :forgeos_core
      assert_response :success
    end

    test "should keep flash for notifications" do
      xhr :get, :keep_flash_test, nil, nil, { :notice => 'test' }
      get :notifications, :use_route => :forgeos_core
      assert_match /\"notice\":\"test\"/, @response.body
    end

    test "should store location on restricted_access" do
      get :login_required_test
      assert_equal '/login_required_test', session[:return_to]
    end

    test "should redirect to login page on restricted_access" do
      get :login_required_test
      assert_redirected_to '/login'
    end

    test "should log_visit" do
      assert_difference 'VisitorCounter.count', 1 do
        get :notifications, :use_route => :forgeos_core
      end
    end

    test "should not log_visit if already counted" do
      @request.cookies[:visitor_counter] = true
      assert_no_difference 'VisitorCounter.count' do
        get :notifications, :use_route => :forgeos_core
      end
    end
  end
end
