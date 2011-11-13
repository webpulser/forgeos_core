require 'test_helper'

class Admin::TagsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  test "should post create" do
    admin_login_to('admin/tags','create')
    post :create, :tag => 'test',:use_route => :forgeos_core
    assert_response :success
  end

  test "should post create with existing tag" do
    ActsAsTaggableOn::Tag.create(:name => 'test')
    admin_login_to('admin/tags','create')
    post :create, :tag => 'test',:use_route => :forgeos_core
    assert_response :success
    assert_match '["test"]', @response.body
  end

end
