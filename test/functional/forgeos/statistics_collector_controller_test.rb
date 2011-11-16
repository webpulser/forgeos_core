require 'test_helper'

module Forgeos
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
      get :index, :type => 'forgeos/administrator', :use_route => :forgeos_core
      assert_response :success
    end

    test "should get index with not existing record given" do
      get :index, :type => 'forgeos/user', :id => '-1', :use_route => :forgeos_core
      assert_response :success
    end

    test "should increment viewed_counter" do
      assert_difference 'UserViewedCounter.count', 1 do
        get :index, :type => 'forgeos/user', :id => forgeos_people(:user).id, :use_route => :forgeos_core
      end
    end

    test "should add record id in a cookie" do
      assert_nil cookies[:"seen_forgeos_users"]
      get :index, :type => 'forgeos/user', :id => forgeos_people(:user).id, :use_route => :forgeos_core
      assert_equal ",#{forgeos_people(:user).id}", cookies[:"seen_forgeos/users"]
    end

    test "should skip if already incremented" do
      @request.cookies[:"seen_forgeos/users"] = ",#{forgeos_people(:user).id}"
      assert_equal ",#{forgeos_people(:user).id}", cookies[:"seen_forgeos/users"]
      assert_no_difference 'UserViewedCounter.count' do
        get :index, :type => 'forgeos/user', :id => forgeos_people(:user).id, :use_route => :forgeos_core
      end
    end
  end
end
