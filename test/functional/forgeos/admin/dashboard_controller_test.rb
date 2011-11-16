require 'test_helper'

module Forgeos
  class Admin::DashboardControllerTest < ActionController::TestCase
    setup :activate_authlogic

    test "should change locale" do
      admin_login_to('admin/dashboard', 'change_lang')
      @request.env['HTTP_REFERER'] = 'http:/test.host/admin'
      get :change_lang, :lang => 'fr',  :use_route => :forgeos_core
      assert_redirected_to :back
      assert_equal :fr, session[:lang]
    end

    test "should not change locale if unsupported" do
      admin_login_to('admin/dashboard', 'change_lang')
      @request.env['HTTP_REFERER'] = 'http:/test.host/admin'
      get :change_lang, :lang => 'de', :use_route => :forgeos_core
      assert_redirected_to :back
      assert_equal :en, session[:lang]
    end

  end
end
