require 'test_helper'

module Forgeos
  class Admin::ImportControllerTest < ActionController::TestCase
    setup :activate_authlogic

    test "should get index" do
      admin_login_to('admin/import', 'index')
      get :index, :use_route => :forgeos_core
      assert_equal ['user'], assigns(:models)
    end

    test "should raise missing file create_user" do
      admin_login_to('admin/import', 'create_user')
      get :create_user, :use_route => :forgeos_core, :parser_options => { :col_sep => ',', :quote_char => '"' }
      assert_redirected_to '/admin/import'
      assert_equal 'missing file', flash[:error]
    end

    test "should display fields form mapper for user" do
      admin_login_to('admin/import', 'create_user')
      get :create_user, :use_route => :forgeos_core, :file => Rack::Test::UploadedFile.new(File.expand_path('../../../../files/users.csv', __FILE__),'text/csv'), :parser_options => { :col_sep => ',', :quote_char => '"' }
      assert_response :success
      assert_template ['forgeos/admin/import/_map_fields', 'forgeos/admin/import/create']
    end

    test "should launch the import for user" do
      admin_login_to('admin/import', 'create_user')
      get :create_user, :use_route => :forgeos_core, :file => Rack::Test::UploadedFile.new(File.expand_path('../../../../files/users.csv', __FILE__),'text/csv'), :parser_options => { :col_sep => ',', :quote_char => '"' }
      get :create_user, :use_route => :forgeos_core, :fields => { '0' => 0, '1' => 1, '2' => 2 }, :ignore_first_row => true
      assert_redirected_to '/admin/import'
      assert_equal 'You will receive an email once this import was completed', flash[:notice]
    end

    test "should create an import set user" do
      admin_login_to('admin/import', 'create_user')
      get :create_user, :use_route => :forgeos_core, :file => Rack::Test::UploadedFile.new(File.expand_path('../../../../files/users.csv', __FILE__),'text/csv'), :parser_options => { :col_sep => ',', :quote_char => '"' }
      assert_difference('ImportSet.count', 1) do
        get :create_user, :use_route => :forgeos_core, :fields => { '0' => 0, '1' => 1, '2' => 2 }, :ignore_first_row => true, :set_name => 'users', :save_set => true
      end
    end

    test "should update an import set user" do
      admin_login_to('admin/import', 'create_user')
      get :create_user, :use_route => :forgeos_core, :file => Rack::Test::UploadedFile.new(File.expand_path('../../../../files/users.csv', __FILE__),'text/csv'), :parser_options => { :col_sep => ',', :quote_char => '"' }
      assert_equal 'users', forgeos_import_sets(:users).name
      assert_difference('ImportSet.count', 0) do
        get :create_user, :use_route => :forgeos_core, :fields => { '0' => 0, '1' => 1, '2' => 2 }, :ignore_first_row => true, :set_name => 'users updated', :save_set => true, :import => { :set_id => forgeos_import_sets(:users).id }
      end
      assert_equal 'users updated', forgeos_import_sets(:users).reload.name
    end

  end
end
