require 'test_helper'

module Forgeos
  class Admin::StatisticsControllerTest < ActionController::TestCase
    setup :activate_authlogic

    test "should get index" do
      admin_login_to('admin/statistics','index')
      get :index, :use_route => :forgeos_core
      assert_response :success
      assert_equal Date.current.ago(1.week).to_date..Date.current, assigns(:date)
      assert_equal({}, assigns(:keywords))
      assert_not_nil assigns(:graph)
    end

    test "should get index for date is today" do
      admin_login_to('admin/statistics','index')
      get :index, :timestamp => 'today', :use_route => :forgeos_core
      assert_response :success
      assert_equal [Date.current], assigns(:date)
      assert_equal({}, assigns(:keywords))
      assert_not_nil assigns(:graph)
    end

    test "should get index for date is yesterday" do
      admin_login_to('admin/statistics','index')
      get :index, :timestamp => 'yesterday', :use_route => :forgeos_core
      assert_response :success
      assert_equal Date.yesterday..Date.current, assigns(:date)
      assert_equal({}, assigns(:keywords))
      assert_not_nil assigns(:graph)
    end

    test "should get index for date is month" do
      admin_login_to('admin/statistics','index')
      get :index, :timestamp => 'month', :use_route => :forgeos_core
      assert_response :success
      assert_equal Date.current.ago(1.month).to_date..Date.current, assigns(:date)
      assert_equal({}, assigns(:keywords))
      assert_not_nil assigns(:graph)
    end

    test "should get graph" do
      admin_login_to('admin/statistics','graph')
      get :graph, :use_route => :forgeos_core
      assert_response :success
      assert_equal Date.current.ago(1.week).to_date..Date.current, assigns(:date)
      assert_match /\"values\":\[0,0,0,0,0,0,0,0\]/, @response.body
    end

    test "should get graph for date is today" do
      admin_login_to('admin/statistics','graph')
      get :graph, :timestamp => 'today', :use_route => :forgeos_core
      assert_response :success
      assert_equal [Date.current], assigns(:date)
      assert_match /\"values\":\[0\]/, @response.body
    end

    test "should get graph for date is yesterday" do
      admin_login_to('admin/statistics','graph')
      get :graph, :timestamp => 'yesterday', :use_route => :forgeos_core
      assert_response :success
      assert_equal Date.yesterday..Date.current, assigns(:date)
      assert_match /\"values\":\[0,0\]/, @response.body
    end

    test "should get graph for date is month" do
      admin_login_to('admin/statistics','graph')
      get :graph, :timestamp => 'month', :use_route => :forgeos_core
      assert_response :success
      assert_equal Date.current.ago(1.month).to_date..Date.current, assigns(:date)
      assert_match /\"values\":\[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,/, @response.body
    end

  end
end
