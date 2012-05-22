require 'test_helper'

module Forgeos
  class Admin::RightsControllerTest < ActionController::TestCase
    setup :activate_authlogic

    #########################
    # Testing index method  #
    #########################
    test "should get index as html" do
      admin_login_to('admin/rights', 'index')
      get :index, :use_route => :forgeos_core
      assert_response :success
    end

    test "should get index as json" do
      admin_login_to('admin/rights', 'index')
      get :index, :format => 'json', :sEcho => 0, :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalDisplayRecords\":2/, @response.body
      assert_match /\"iTotalRecords\":2/, @response.body
      assert_match /\"sEcho\":\"0\"/, @response.body
      assert_match 'right', @response.body
    end

    test "should get index as json with category" do
      admin_login_to('admin/rights', 'index')
      get :index, :format => 'json', :sEcho => 0, :use_route => :forgeos_core, :category_id => 1
      assert_response :success
      assert_match /\"iTotalDisplayRecords\":0/, @response.body
      assert_match /\"iTotalRecords\":2/, @response.body
      assert_match /\"sEcho\":\"0\"/, @response.body
    end

    test "should get index as json with sorting by count" do
      admin_login_to('admin/rights', 'index')
      get :index, :format => 'json', :sEcho => 0, :iSortCol_0 => 2, :sSortDir_0 => 'DESC', :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":2/, @response.body
      assert_match /right/, @response.body
    end

    test "should get index as json to search right with sorting by name" do
      admin_login_to('admin/rights', 'index')
      get :index, :format => 'json', :sSearch => 'right', :sEcho => 0, :iSortCol_0 => 1, :sSortDir_0 => 'DESC', :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":2/, @response.body
      assert_match /\"iTotalDisplayRecords\":1/, @response.body
      assert_match /right/, @response.body
    end

    #########################
    #  Testing show method  #
    #########################

    test "should get show" do
      admin_login_to('admin/rights','show')
      get :show, :id => forgeos_rights(:right).id, :use_route => :forgeos_core
      assert_response :success
      assert_equal forgeos_rights(:right), assigns(:right)
      assert_template 'admin/rights/show'
    end

    test "should not get show" do
      admin_login_to('admin/rights','show')
      get :show, :id => 0, :use_route => :forgeos_core
      assert_redirected_to '/admin/rights'
      assert_not_nil flash[:error]
    end

    #########################
    #  Testing edit method  #
    #########################

    test "should get edit" do
      admin_login_to('admin/rights', 'edit')
      get :edit, :id => forgeos_rights(:right).id, :use_route => :forgeos_core
      assert_response :success
      assert_equal forgeos_rights(:right), assigns(:right)
      assert_template 'admin/rights/edit'
      assert_template 'admin/rights/_form'
    end

    test "should not get edit" do
      admin_login_to('admin/rights','edit')
      get :edit, :id => 0, :use_route => :forgeos_core
      assert_redirected_to '/admin/rights'
      assert_not_nil flash[:error]
    end

    #########################
    #  Testing new method   #
    #########################

    test "should get new" do
      admin_login_to('admin/rights', 'new')
      get :new, :use_route => :forgeos_core
      assert_response :success
      assert assigns(:right).new_record?, "right is not a new record"
      assert_template 'admin/rights/new'
      assert_template 'admin/rights/_form'
    end

    test "should get new with params" do
      admin_login_to('admin/rights', 'new')
      get :new, :right => { :name => 'test' },:use_route => :forgeos_core
      assert_response :success
      assert assigns(:right).new_record?, "right is not a new record"
      assert_equal 'test', assigns(:right).name
    end

    #########################
    # Testing create method #
    #########################

    test "should post create" do
      admin_login_to('admin/rights', 'create')
      assert_difference 'Right.count', 1 do
        post :create, :right => {
          :name => 'test',
          :action_name => 'test',
          :controller_name => 'test'
        }, :use_route => :forgeos_core
      end

      assert_redirected_to "/admin/rights/#{assigns(:right).id}/edit"
      assert !assigns(:right).new_record?, "right not saved"
      assert_equal 'test', assigns(:right).name
    end

    test "should post create in xhr" do
      admin_login_to('admin/rights', 'create')
      assert_difference 'Right.count', 1 do
        xhr :post, :create, :right => {
          :name => 'test',
          :action_name => 'test',
          :controller_name => 'test'
        }, :use_route => :forgeos_core
      end

      assert_response :success
      assert !assigns(:right).new_record?, "right not saved"
      assert_equal 'test', assigns(:right).name
    end

    test "should post create with invalid record" do
      admin_login_to('admin/rights', 'create')
      assert_no_difference 'Right.count', 1 do
        post :create, :right => {}, :use_route => :forgeos_core
      end

      assert_response :success
      assert !assigns(:right).valid?, "right is valid and should not be"
      assert assigns(:right).new_record?, "right is not a new record"
      assert_template 'admin/rights/new'
      assert_not_nil flash[:error]
    end

    test "should post create with invalid record in xhr" do
      admin_login_to('admin/rights', 'create')
      assert_no_difference 'Right.count', 1 do
        xhr :post, :create, :right => {}, :use_route => :forgeos_core
      end

      assert_response :success
      assert !assigns(:right).valid?, "right is valid and should not be"
      assert assigns(:right).new_record?, "right is not a new record"
      assert_match '"result":"error"', @response.body
      assert_not_nil flash[:error]
    end

    #########################
    # Testing update method #
    #########################

    test "should put update" do
      admin_login_to('admin/rights', 'update')
      put :update, :id => forgeos_rights(:right).id, :right => {
        :name => 'test',
        :action_name => 'test',
        :controller_name => 'test'
      }, :use_route => :forgeos_core

      assert_response :success
      assert_equal forgeos_rights(:right), assigns(:right)
      assert_equal 'test', forgeos_rights(:right).reload.name
      assert_template 'admin/rights/edit'
    end

    test "should put update in xhr" do
      admin_login_to('admin/rights', 'update')
      xhr :put, :update, :id => forgeos_rights(:right).id, :right => {
        :name => 'test',
        :action_name => 'test',
        :controller_name => 'test'
      }, :use_route => :forgeos_core

      assert_response :success
      assert_equal forgeos_rights(:right), assigns(:right)
      assert_equal 'test', forgeos_rights(:right).reload.name
    end

    test "should put update with invalid record" do
      admin_login_to('admin/rights', 'update')
      put :update, :id => forgeos_rights(:right).id, :right => { :name => nil}, :use_route => :forgeos_core

      assert_response :success
      assert_equal forgeos_rights(:right), assigns(:right)
      assert !assigns(:right).valid?, "right is valid and should not be"
      assert_not_equal 'test', forgeos_rights(:right).reload.name
      assert_template 'admin/rights/edit'
    end

    test "should put update with invalid record in xhr" do
      admin_login_to('admin/rights', 'update')
      xhr :put, :update, :id => forgeos_rights(:right).id, :right => { :name => nil}, :use_route => :forgeos_core

      assert_response :success
      assert_equal forgeos_rights(:right), assigns(:right)
      assert !assigns(:right).valid?, "right is valid and should not be"
      assert_not_equal 'test', forgeos_rights(:right).reload.name
      assert_match '"result":"error"', @response.body
    end

    ##########################
    # Testing destroy method #
    ##########################

    test "should delete destroy" do
      admin_login_to('admin/rights', 'destroy')
      assert_difference 'Right.count', -1 do
        delete :destroy, :id => forgeos_rights(:right).id, :use_route => :forgeos_core
      end

      assert_redirected_to '/admin/rights'
    end

    test "should not delete destroy" do
      Right.class_eval do
        before_destroy do
          return false
        end
      end

      admin_login_to('admin/rights', 'destroy')
      assert_no_difference 'Right.count', -1 do
        delete :destroy, :id => forgeos_rights(:right).id, :use_route => :forgeos_core
      end

      assert_redirected_to '/admin/rights'
      assert_not_nil flash[:error]
    end
  end
end
