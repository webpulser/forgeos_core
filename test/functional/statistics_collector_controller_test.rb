require 'test_helper'

class StatisticsCollectorControllerTest < ActionController::TestCase
  class ::UserViewedCounter < StatisticCounter
  end

  User.class_eval do
    has_many :viewed_counters,
      :as => :element,
      :class_name => 'UserViewedCounter',
      :dependent => :destroy

  end


  test "should get index" do
    get :index, :use_route => :forgeos_core
    assert_response :success
  end

  test "should get index with unknown type given" do
    get :index, :type => 'test', :use_route => :forgeos_core
    assert_response :success
  end

  test "should get index with type without viewed_counter given" do
    get :index, :type => 'administrator', :use_route => :forgeos_core
    assert_response :success
  end

  test "should get index with not existing record given" do
    get :index, :type => 'user', :id => '-1', :use_route => :forgeos_core
    assert_response :success
  end

  test "should increment viewed_counter" do
    assert_difference 'UserViewedCounter.count', 1 do
      get :index, :type => 'user', :id => people(:user).id, :use_route => :forgeos_core
    end
  end

  test "should add record id in a cookie" do
    assert_nil cookies[:seen_users]
    get :index, :type => 'user', :id => people(:user).id, :use_route => :forgeos_core
    assert_equal ",#{people(:user).id}", cookies[:seen_users]
  end

  test "should skip if already incremented" do
    @request.cookies[:seen_users] = ",#{people(:user).id}"
    assert_equal ",#{people(:user).id}", cookies[:seen_users]
    assert_no_difference 'UserViewedCounter.count' do
      get :index, :type => 'user', :id => people(:user).id, :use_route => :forgeos_core
    end
  end
end
