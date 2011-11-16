require 'test_helper'

module Forgeos
  class Admin::AdministratorsControllerTest < ActionController::TestCase
    setup :activate_authlogic

    test "should get index" do
      admin_login_to('admin/administrators', 'index')
      get :index, :use_route => :forgeos_core
      assert_response :success
    end

    test "should be the current tab" do
      admin_login_to('admin/administrators', 'index')
      @request.path = '/admin/administrators' # fix ActionController::TestCase request path is '/'
      get :index, :use_route => :forgeos_core
      assert_select 'ul.ui-tabs-nav' do
        assert_select 'li.ui-tabs-selected a', 'Administrators'
        assert_select 'li.ui-tabs-selected a span.small-icons.administrator', true
      end
    end

    test "should be the current menu entry" do
      admin_login_to('admin/administrators', 'index')
      @request.path = '/admin/administrators' # fix ActionController::TestCase request path is '/'
      get :index, :use_route => :forgeos_core
      assert_select '#submenu' do
        assert_select '> li.current a', 'Administrators'
        assert_select '> li.current ul', true
      end
    end
  end
end
