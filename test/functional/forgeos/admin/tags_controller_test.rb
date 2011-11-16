require 'test_helper'

module Forgeos
  class Admin::TagsControllerTest < ActionController::TestCase
    setup :activate_authlogic
    test "should get index" do
      admin_login_to('admin/tags','index')
      get :index, :tag => 'test',:use_route => :forgeos_core
      assert_response :success
    end

    test "should get index with existing tag" do
      ActsAsTaggableOn::Tag.create(:name => 'test')
      admin_login_to('admin/tags','index')
      get :index, :tag => 'test',:use_route => :forgeos_core
      assert_response :success
      assert_match '["test"]', @response.body
    end

  end
end
