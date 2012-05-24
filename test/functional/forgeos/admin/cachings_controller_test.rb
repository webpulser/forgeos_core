require 'test_helper'

module Forgeos
  class Admin::CachingsControllerTest < ActionController::TestCase
    setup :activate_authlogic

    test "should get index as html" do
      admin_login_to('admin/cachings', 'index')
      get :index, :use_route => :forgeos_core
      assert_response :success
    end

    test "should get index as json" do
      admin_login_to('admin/cachings', 'index')
      get :index, :use_route => :forgeos_core, :id => 0, :format => :json
      assert_response :success
      assert_equal [Rails.configuration.action_controller.page_cache_directory, Rails.cache.cache_path], assigns(:files)
    end

    test "should get index as json with file" do
      admin_login_to('admin/cachings', 'index')
      get :index, :use_route => :forgeos_core, :id => File.join(Rails.configuration.action_controller.page_cache_directory, 'index.html'), :format => :json
      assert_response :success
      assert_equal [], assigns(:files)
    end

    test "should get index as json with directory" do
      admin_login_to('admin/cachings', 'index')
      files = %w(favicon.ico 500.html 422.html 404.html).map do |fn|
        File.join(Rails.configuration.action_controller.page_cache_directory, fn)
      end
      get :index, :use_route => :forgeos_core, :id => Rails.configuration.action_controller.page_cache_directory, :format => :json
      assert_response :success
      assert_equal files.sort, assigns(:files).sort
    end

    test "should post create" do
      admin_login_to('admin/cachings', 'create')
      files = [File.join(Rails.configuration.action_controller.page_cache_directory,'toto.cache')]
      File.open(files.first, 'w') {|f| f.write('') }
      assert File.exist?(files.first)
      post :create, :use_route => :forgeos_core, :files => files
      assert !File.exist?(files.first)
      assert_redirected_to '/admin/cachings'
      assert_equal files, assigns(:files)
      assert_nil flash[:error]
      assert_not_nil flash[:notice]
    end

    test "should post create with unexisting file" do
      admin_login_to('admin/cachings', 'create')
      files = [File.join(Rails.configuration.action_controller.page_cache_directory,'toto.cache')]
      assert !File.exist?(files.first), "#{files.first} file exist and should not"
      post :create, :use_route => :forgeos_core, :files => files
      assert_redirected_to '/admin/cachings'
      assert_equal files, assigns(:files)
      assert_not_nil flash[:notice]
    end

    test "should post create without files" do
      admin_login_to('admin/cachings', 'create')
      post :create, :use_route => :forgeos_core
      assert_redirected_to '/admin/cachings'
      assert_equal nil, assigns(:files)
      assert_not_nil flash[:error]
      assert_nil flash[:notice]
    end

    test "should purge cache" do
      admin_login_to('admin/cachings', 'create')
      files = %w(favicon.ico 500.html 422.html 404.html).map do |fn|
        File.join(Rails.configuration.action_controller.page_cache_directory, fn)
      end
      tmp_file = File.join(Rails.cache.cache_path,'test.cache')
      File.open(tmp_file, 'w') {|f| f.write('') }
      files << tmp_file
      post :create, :use_route => :forgeos_core, :commit => I18n.t('caching.delete.all').capitalize
      assert_redirected_to '/admin/cachings'
      assert_not_nil flash[:notice]
      assert_nil flash[:error]

      files.each do |file|
        assert !File.exist?(file), "#{file} file exist and should not"
      end

      %x(git checkout #{Rails.configuration.action_controller.page_cache_directory} #{Rails.cache.cache_path})
    end
  end
end
