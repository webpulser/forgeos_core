require 'test_helper'

module Forgeos
  class Admin::RolesControllerTest < ActionController::TestCase
    setup :activate_authlogic

    #########################
    # Testing index method  #
    #########################
    test "should get index as html" do
      admin_login_to('admin/roles', 'index')
      get :index, :use_route => :forgeos_core
      assert_response :success
    end

    test "should get index as json" do
      admin_login_to('admin/roles', 'index')
      get :index, :format => 'json', :sEcho => 0, :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalDisplayRecords\":2/, @response.body
      assert_match /\"iTotalRecords\":2/, @response.body
      assert_match /\"sEcho\":0/, @response.body
      assert_match 'role', @response.body
    end

    test "should get index as json with category" do
      admin_login_to('admin/roles', 'index')
      get :index, :format => 'json', :sEcho => 0, :use_route => :forgeos_core, :category_id => 1
      assert_response :success
      assert_match /\"iTotalDisplayRecords\":0/, @response.body
      assert_match /\"iTotalRecords\":2/, @response.body
      assert_match /\"sEcho\":0/, @response.body
    end

    test "should get index as json with sorting by count" do
      admin_login_to('admin/roles', 'index')
      get :index, :format => 'json', :sEcho => 0, :iSortCol_0 => 2, :sSortDir_0 => 'DESC', :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":2/, @response.body
      assert_match /role/, @response.body
    end

    test "should get index as json to search role with sorting by name" do
      admin_login_to('admin/roles', 'index')
      get :index, :format => 'json', :sSearch => 'role', :sEcho => 0, :iSortCol_0 => 1, :sSortDir_0 => 'DESC', :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":2/, @response.body
      assert_match /\"iTotalDisplayRecords\":1/, @response.body
      assert_match /role/, @response.body
    end

    #########################
    #  Testing show method  #
    #########################

    test "should get show" do
      admin_login_to('admin/roles','show')
      get :show, :id => forgeos_roles(:role).id, :use_route => :forgeos_core
      assert_response :success
      assert_equal forgeos_roles(:role), assigns(:role)
      assert_template 'admin/roles/show'
    end

    test "should not get show" do
      admin_login_to('admin/roles','show')
      get :show, :id => 0, :use_route => :forgeos_core
      assert_redirected_to '/admin/roles'
      assert_not_nil flash[:alert]
    end

    #########################
    #  Testing edit method  #
    #########################

    test "should get edit" do
      admin_login_to('admin/roles', 'edit')
      get :edit, :id => forgeos_roles(:role).id, :use_route => :forgeos_core
      assert_response :success
      assert_equal forgeos_roles(:role), assigns(:role)
      assert_template 'admin/roles/edit'
      assert_template 'admin/roles/_form'
    end

    test "should not get edit" do
      admin_login_to('admin/roles','edit')
      get :edit, :id => 0, :use_route => :forgeos_core
      assert_redirected_to '/admin/roles'
      assert_not_nil flash[:alert]
    end

    #########################
    #  Testing new method   #
    #########################

    test "should get new" do
      admin_login_to('admin/roles', 'new')
      get :new, :use_route => :forgeos_core
      assert_response :success
      assert assigns(:role).new_record?, "role is not a new record"
      assert_template 'admin/roles/new'
      assert_template 'admin/roles/_form'
    end

    test "should get new with params" do
      admin_login_to('admin/roles', 'new')
      get :new, :role => { :name => 'test' },:use_route => :forgeos_core
      assert_response :success
      assert assigns(:role).new_record?, "role is not a new record"
      assert_equal 'test', assigns(:role).name
    end

    #########################
    # Testing create method #
    #########################

    test "should post create" do
      admin_login_to('admin/roles', 'create')
      assert_difference 'Role.count', 1 do
        post :create, :role => {
          :name => 'test'
        }, :use_route => :forgeos_core
      end

      assert_redirected_to "/admin/roles/#{assigns(:role).id}/edit"
      assert !assigns(:role).new_record?, "role not saved"
      assert_equal 'test', assigns(:role).name
    end

    test "should post create with invalid record" do
      admin_login_to('admin/roles', 'create')
      assert_no_difference 'Role.count', 1 do
        post :create, :role => {}, :use_route => :forgeos_core
      end

      assert_response :success
      assert !assigns(:role).valid?, "role is valid and should not be"
      assert assigns(:role).new_record?, "role is not a new record"
      assert_template 'admin/roles/new'
      assert_not_nil flash[:alert]
    end

    #########################
    # Testing update method #
    #########################

    test "should put update" do
      admin_login_to('admin/roles', 'update')
      put :update, :id => forgeos_roles(:role).id, :role => {
        :name => 'test'
      }, :use_route => :forgeos_core

      assert_response :success
      assert_equal forgeos_roles(:role), assigns(:role)
      assert_equal 'test', forgeos_roles(:role).reload.name
      assert_template 'admin/roles/edit'
    end

    test "should put update with invalid record" do
      admin_login_to('admin/roles', 'update')
      put :update, :id => forgeos_roles(:role).id, :role => { :name => nil}, :use_route => :forgeos_core

      assert_response :success
      assert_equal forgeos_roles(:role), assigns(:role)
      assert !assigns(:role).valid?, "role is valid and should not be"
      assert_not_equal 'test', forgeos_roles(:role).reload.name
      assert_template 'admin/roles/edit'
    end

    ##########################
    # Testing destroy method #
    ##########################

    test "should delete destroy" do
      admin_login_to('admin/roles', 'destroy')
      assert_difference 'Role.count', -1 do
        delete :destroy, :id => forgeos_roles(:role).id, :use_route => :forgeos_core
      end

      assert_redirected_to '/admin/roles'
    end

    test "should not delete destroy" do
      Role.class_eval do
        before_destroy do
          return false
        end
      end

      admin_login_to('admin/roles', 'destroy')
      assert_no_difference 'Role.count', -1 do
        delete :destroy, :id => forgeos_roles(:role).id, :use_route => :forgeos_core
      end

      assert_redirected_to '/admin/roles'
      assert_not_nil flash[:alert]
    end

    ############################
    # Testing duplicate method #
    ############################

    test "should get duplicate" do
      admin_login_to('admin/roles', 'duplicate')
      get :duplicate, :use_route => :forgeos_core, :id => forgeos_roles(:role).id
      assert_response :success
      assert assigns(:role).new_record?, "role is not a new record"
      assert_equal 'role', assigns(:role).name
      assert_template 'admin/roles/new'
      assert_template 'admin/roles/_form'
    end

    ############################
    # Testing activate method #
    ############################

    test "should post activate" do
      admin_login_to('admin/roles', 'activate')
      assert forgeos_roles(:role).active?, 'role not active and should be initialy'
      post :activate, :use_route => :forgeos_core, :id => forgeos_roles(:role).id
      assert !forgeos_roles(:role).reload.active?, 'role disactivation not working'
    end

    test "should post activate in js" do
      admin_login_to('admin/roles', 'activate')
      assert forgeos_roles(:role).active?, 'role not active and should be initialy'
      post :activate, :use_route => :forgeos_core, :id => forgeos_roles(:role).id, :format => 'js'
      assert !forgeos_roles(:role).reload.active?, 'role disactivation not working'
      assert_match /toggleActivate/, @response.body
    end
  end
end
