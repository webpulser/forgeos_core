require 'test_helper'

module Forgeos
  class Admin::CategoriesControllerTest < ActionController::TestCase
    setup :activate_authlogic

    test "should get index" do
      admin_login_to('admin/categories', 'index')
      get :index, :use_route => :forgeos_core
      assert_redirected_to('/admin')
    end

    test "should get index as json without type" do
      admin_login_to('admin/categories', 'index')
      get :index, :use_route => :forgeos_core, :format => :json
      assert_redirected_to '/admin'
    end

    test "should get index as json with type" do
      admin_login_to('admin/categories', 'index')
      get :index, :use_route => :forgeos_core, :format => :json, :type => 'Forgeos::UserCategory'
      assert_response :success
      assert_equal 'application/json; charset=utf-8', @response.headers['Content-Type']
    end

    test "should get index as json with id is 0" do
      admin_login_to('admin/categories', 'index')
      get :index, :use_route => :forgeos_core, :format => :json, :id => 0, :type => 'Forgeos::UserCategory'
      assert_response :success
      assert_equal 'application/json; charset=utf-8', @response.headers['Content-Type']
      assert_equal Forgeos::UserCategory.roots, assigns(:categories)
    end

    test "should get index as json with id" do
      admin_login_to('admin/categories', 'index')
      get :index, :use_route => :forgeos_core, :format => :json, :id => forgeos_categories(:user_cat).id, :type => 'Forgeos::UserCategory'
      assert_response :success
      assert_equal 'application/json; charset=utf-8', @response.headers['Content-Type']
      assert_equal [], assigns(:categories)
    end

    test "should get new" do
      admin_login_to('admin/categories', 'new')
      get :new, :use_route => :forgeos_core
      assert_response :success
    end

    test "should post create" do
      admin_login_to('admin/categories', 'create')
      assert_difference('Category.count', 1) do
        post :create, :use_route => :forgeos_core, :category => { :name => 'test' }
      end
      assert_not_nil flash[:notice]
      assert_nil flash[:error]
      assert_kind_of Category, assigns(:category)
      assert_redirected_to "/admin/categories/#{assigns(:category).id}/edit"
    end

    test "should not post create" do
      admin_login_to('admin/categories', 'create')
      assert_no_difference('Category.count', 1) do
        post :create, :use_route => :forgeos_core, :category => { :name => nil }
      end
      assert_nil flash[:notice]
      assert_not_nil flash[:error]
      assert_response :success
    end

    test "should get edit" do
      admin_login_to('admin/categories', 'edit')
      get :edit, :use_route => :forgeos_core, :id => forgeos_categories(:user_cat).id
      assert_response :success
      assert_equal forgeos_categories(:user_cat), assigns(:category)
    end

    test "should not get edit" do
      admin_login_to('admin/categories', 'edit')
      get :edit, :use_route => :forgeos_core, :id => 0
      assert_redirected_to '/admin/categories'
      assert_nil assigns(:category)
    end

    test "should put update" do
      admin_login_to('admin/categories', 'update')
      put :update, :use_route => :forgeos_core, :id => forgeos_categories(:user_cat).id, :category => { :name => 'test updated' }
      assert_not_nil flash[:notice]
      assert_nil flash[:error]
      assert_kind_of UserCategory, assigns(:category)
      assert_equal 'test updated', forgeos_categories(:user_cat).reload.name
      assert_redirected_to "/admin/user_categories/#{assigns(:category).id}/edit"
    end

    test "should not put update" do
      admin_login_to('admin/categories', 'update')
      put :update, :use_route => :forgeos_core, :category => { :name => nil }, :id => forgeos_categories(:user_cat).id
      assert_response :success
      assert_nil flash[:notice]
      assert_not_nil flash[:error]
    end

    ##########################
    # Testing destroy method #
    ##########################

    test "should delete destroy" do
      admin_login_to('admin/categories', 'destroy')
      assert_difference 'Category.count', -1 do
        delete :destroy, :id => forgeos_categories(:user_cat).id, :use_route => :forgeos_core
      end

      assert_redirected_to '/admin/categories'
    end

    test "should delete destroy in json" do
      admin_login_to('admin/categories', 'destroy')
      assert_difference 'Category.count', -1 do
        delete :destroy, :format => 'json', :id => forgeos_categories(:user_cat).id, :use_route => :forgeos_core
      end

      assert_response :success
    end

    test "should not delete destroy" do
      Category.class_eval do
        before_destroy do
          return false
        end
      end

      admin_login_to('admin/categories', 'destroy')
      assert_no_difference 'Category.count', -1 do
        delete :destroy, :id => forgeos_categories(:user_cat).id, :use_route => :forgeos_core
      end

      assert_redirected_to '/admin/categories'
      assert_not_nil flash[:error]
    end

    test "should not delete destroy in json" do
      Category.class_eval do
        before_destroy do
          return false
        end
      end

      admin_login_to('admin/categories', 'destroy')
      assert_no_difference 'Category.count', -1 do
        delete :destroy, :format => 'json', :id => forgeos_categories(:user_cat).id, :use_route => :forgeos_core
      end

      assert_response :success
      assert_not_nil flash[:error]
    end

    test "should post add_element" do
      admin_login_to('admin/categories', 'add_element')
      post :add_element, :use_route => :forgeos_core, :id => forgeos_categories(:user_cat).id, :element_id => forgeos_people(:user).id
      assert_response :success
      assert forgeos_categories(:user_cat).reload.elements.include?(forgeos_people(:user)), "the element has not be added to the category"
    end
  end
end
