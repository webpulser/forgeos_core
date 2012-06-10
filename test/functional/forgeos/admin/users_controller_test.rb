require 'test_helper'

module Forgeos
  class Admin::UsersControllerTest < ActionController::TestCase
    setup :activate_authlogic

    #########################
    # Testing index method  #
    #########################
    test "should get index as html" do
      admin_login_to('admin/users', 'index')
      get :index, :use_route => :forgeos_core
      assert_response :success
    end

    test "should get index as json" do
      admin_login_to('admin/users', 'index')
      get :index, :format => 'json', :sEcho => 0, :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalDisplayRecords\":3/, @response.body
      assert_match /\"iTotalRecords\":3/, @response.body
      assert_match /\"sEcho\":0/, @response.body
      assert_match 'john.doe@forgeos.com', @response.body
    end

    test "should get index as json with category_id" do
      admin_login_to('admin/users', 'index')
      get :index, :format => 'json', :sEcho => 0, :use_route => :forgeos_core, :category_id => 1
      assert_response :success
      assert_match /\"iTotalDisplayRecords\":0/, @response.body
      assert_match /\"iTotalRecords\":3/, @response.body
      assert_match /\"sEcho\":0/, @response.body
    end

    test "should get index as json with ids" do
      admin_login_to('admin/users', 'index')
      get :index, :format => 'json', :sEcho => 0, :use_route => :forgeos_core, :ids => [forgeos_people(:user).id]
      assert_response :success
      assert_match /\"iTotalDisplayRecords\":1/, @response.body
      assert_match /\"iTotalRecords\":3/, @response.body
      assert_match /\"sEcho\":0/, @response.body
      assert_match 'john.doe@forgeos.com', @response.body
    end

    test "should get index as json with sorting by id" do
      admin_login_to('admin/users', 'index')
      get :index, :format => 'json', :sEcho => 0, :iSortCol_0 => 0, :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":3/, @response.body
      assert_match /john\.doe@forgeos\.com.*tintin@forgeos\.com/, @response.body
    end

    test "should get index as json with sorting by name" do
      admin_login_to('admin/users', 'index')
      get :index, :format => 'json', :sEcho => 0, :iSortCol_0 => 1, :sSortDir_0 => 'DESC', :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":3/, @response.body
      assert_match /tintin@forgeos\.com.*john\.doe@forgeos\.com/, @response.body
    end

    test "should get index as json with sorting by email" do
      admin_login_to('admin/users', 'index')
      get :index, :format => 'json', :sEcho => 0, :iSortCol_0 => 2, :sSortDir_0 => 'DESC', :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":3/, @response.body
      assert_match /tintin@forgeos\.com.*john\.doe@forgeos\.com/, @response.body
    end

    test "should get index as json with sorting by active" do
      admin_login_to('admin/users', 'index')
      get :index, :format => 'json', :sEcho => 0, :iSortCol_0 => 3, :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":3/, @response.body
      assert_match /tintin@forgeos\.com.*john\.doe@forgeos\.com/, @response.body
    end

    test "should get index as json to search john" do
      admin_login_to('admin/users', 'index')
      get :index, :format => 'json', :sEcho => 0, :sSearch => 'john', :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":3/, @response.body
      assert_match /\"iTotalDisplayRecords\":2/, @response.body
      assert_match 'john.doe@forgeos.com', @response.body
      assert_match 'john.lennon@forgeos.com', @response.body
    end

    test "should get index as json to search by id" do
      admin_login_to('admin/users', 'index')
      get :index, :format => 'json', :sEcho => 0, :sSearch => "##{forgeos_people(:lennon).id}", :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":3/, @response.body
      assert_match /\"iTotalDisplayRecords\":1/, @response.body
      assert !@response.body.include?('john.doe@forgeos.com')
      assert_match 'john.lennon@forgeos.com', @response.body
    end

    test "should get index as json to search john with sorting by id" do
      admin_login_to('admin/users', 'index')
      get :index, :format => 'json', :sSearch => 'john', :sEcho => 0, :iSortCol_0 => 0, :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":3/, @response.body
      assert_match /\"iTotalDisplayRecords\":2/, @response.body
      assert_match /john\.doe@forgeos\.com.*john\.lennon@forgeos\.com/, @response.body
    end

    test "should get index as json to search john with sorting by name" do
      admin_login_to('admin/users', 'index')
      get :index, :format => 'json', :sSearch => 'john', :sEcho => 0, :iSortCol_0 => 1, :sSortDir_0 => 'DESC', :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":3/, @response.body
      assert_match /\"iTotalDisplayRecords\":2/, @response.body
      assert_match /john\.lennon@forgeos\.com.*john\.doe@forgeos\.com/, @response.body
    end

    test "should get index as json to search john with sorting by email" do
      admin_login_to('admin/users', 'index')
      get :index, :format => 'json', :sSearch => 'john', :sEcho => 0, :iSortCol_0 => 2, :sSortDir_0 => 'DESC', :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":3/, @response.body
      assert_match /\"iTotalDisplayRecords\":2/, @response.body
      assert_match /john\.lennon@forgeos\.com.*john\.doe@forgeos\.com/, @response.body
    end

    test "should get index as json to search john with sorting by active" do
      admin_login_to('admin/users', 'index')
      get :index, :format => 'json', :sSearch => 'john', :sEcho => 0, :iSortCol_0 => 3, :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":3/, @response.body
      assert_match /\"iTotalDisplayRecords\":2/, @response.body
      assert_match /john\.lennon@forgeos\.com.*john\.doe@forgeos\.com/, @response.body
    end

    #########################
    #  Testing show method  #
    #########################

    test "should get show" do
      admin_login_to('admin/users','show')
      get :show, :id => forgeos_people(:user).id, :use_route => :forgeos_core
      assert_response :success
      assert_equal forgeos_people(:user), assigns(:user)
      assert_template 'admin/users/show'
    end

    test "should not get show" do
      admin_login_to('admin/users','show')
      get :show, :id => 0, :use_route => :forgeos_core
      assert_redirected_to '/admin/users'
      assert_not_nil flash[:error]
    end

    #########################
    #  Testing edit method  #
    #########################

    test "should get edit" do
      admin_login_to('admin/users', 'edit')
      get :edit, :id => forgeos_people(:user).id, :use_route => :forgeos_core
      assert_response :success
      assert_equal forgeos_people(:user), assigns(:user)
      assert_template 'admin/users/edit'
      assert_template 'admin/users/_form'
    end

    test "should not get edit" do
      admin_login_to('admin/users','edit')
      get :edit, :id => 0, :use_route => :forgeos_core
      assert_redirected_to '/admin/users'
      assert_not_nil flash[:error]
    end

    #########################
    #  Testing new method   #
    #########################

    test "should get new" do
      admin_login_to('admin/users', 'new')
      get :new, :use_route => :forgeos_core
      assert_response :success
      assert assigns(:user).new_record?, "user is not a new record"
      assert_template 'admin/users/new'
      assert_template 'admin/users/_form'
    end

    test "should get new with params" do
      admin_login_to('admin/users', 'new')
      get :new, :user => { :lastname => 'test' },:use_route => :forgeos_core
      assert_response :success
      assert assigns(:user).new_record?, "user is not a new record"
      assert_equal 'test', assigns(:user).lastname
    end

    #########################
    # Testing create method #
    #########################

    test "should post create" do
      admin_login_to('admin/users', 'create')
      assert_difference 'User.count', 1 do
        post :create, :user => {
          :lastname => 'test',
          :firstname => 'test',
          :email => 'test@forgeos.com',
          :password => 'forgeos',
          :password_confirmation => 'forgeos'
        }, :use_route => :forgeos_core
      end

      assert_redirected_to "/admin/users/#{assigns(:user).id}/edit"
      assert !assigns(:user).new_record?, "user not saved"
      assert_equal 'test', assigns(:user).lastname
    end

    test "should post create with invalid record" do
      admin_login_to('admin/users', 'create')
      assert_no_difference 'User.count', 1 do
        post :create, :user => {
          :lastname => 'test',
          :firstname => 'test'
        }, :use_route => :forgeos_core
      end

      assert_response :success
      assert !assigns(:user).valid?, "user is valid and should not be"
      assert assigns(:user).new_record?, "user is not a new record"
      assert_equal 'test', assigns(:user).lastname
      assert_template 'admin/users/new'
      assert_not_nil flash[:error]
    end

    #########################
    # Testing update method #
    #########################

    test "should put update" do
      admin_login_to('admin/users', 'update')
      put :update, :id => forgeos_people(:user).id, :user => {
        :lastname => 'test',
        :firstname => 'test',
        :email => 'test@forgeos.com',
        :password => 'forgeos',
        :password_confirmation => 'forgeos'
      }, :use_route => :forgeos_core

      assert_response :success
      assert_equal forgeos_people(:user), assigns(:user)
      assert_equal 'test', forgeos_people(:user).reload.lastname
      assert_template 'admin/users/edit'
    end

    test "should put update with invalid record" do
      admin_login_to('admin/users', 'update')
      put :update, :id => forgeos_people(:user).id, :user => {
        :lastname => 'test',
        :email => ''
      }, :use_route => :forgeos_core

      assert_response :success
      assert_equal forgeos_people(:user), assigns(:user)
      assert !assigns(:user).valid?, "user is valid and should not be"
      assert_not_equal 'test', forgeos_people(:user).reload.lastname
      assert_template 'admin/users/edit'
    end

    ##########################
    # Testing destroy method #
    ##########################

    test "should delete destroy" do
      admin_login_to('admin/users', 'destroy')
      assert_difference 'User.count', -1 do
        delete :destroy, :id => forgeos_people(:user).id, :use_route => :forgeos_core
      end

      assert_redirected_to '/admin/users'
    end

    test "should delete destroy in js" do
      admin_login_to('admin/users', 'destroy')
      assert_difference 'User.count', -1 do
        delete :destroy, :format => 'js', :id => forgeos_people(:user).id, :use_route => :forgeos_core
      end

      assert_response :success
    end

    test "should not delete destroy" do
      User.class_eval do
        before_destroy do
          return false
        end
      end

      admin_login_to('admin/users', 'destroy')
      assert_no_difference 'User.count', -1 do
        delete :destroy, :id => forgeos_people(:user).id, :use_route => :forgeos_core
      end

      assert_redirected_to '/admin/users'
      assert_not_nil flash[:error]
    end

    test "should not delete destroy in js" do
      User.class_eval do
        before_destroy do
          return false
        end
      end

      admin_login_to('admin/users', 'destroy')
      assert_no_difference 'User.count', -1 do
        delete :destroy, :format => 'js', :id => forgeos_people(:user).id, :use_route => :forgeos_core
      end

      assert_response :success
      assert_not_nil flash[:error]
    end

    ###########################
    # Testing activate method #
    ###########################

    test "should put activate with active user" do
      admin_login_to('admin/users', 'activate')
      @request.env['HTTP_REFERER'] = 'http://test.host/admin/users'
      put :activate, :id => forgeos_people(:user).id, :use_route => :forgeos_core

      assert_equal forgeos_people(:user), assigns(:user)
      assert !forgeos_people(:user).reload.active?
      assert_redirected_to '/admin/users'
    end

    test "should put activate with unactive user" do
      admin_login_to('admin/users', 'activate')
      forgeos_people(:user).update_attribute(:active, false)
      @request.env['HTTP_REFERER'] = 'http://test.host/admin/users'
      put :activate, :id => forgeos_people(:user).id, :use_route => :forgeos_core

      assert_equal forgeos_people(:user), assigns(:user)
      assert forgeos_people(:user).reload.active?
      assert_redirected_to '/admin/users'
    end

    test "should not put activate with active user" do
      admin_login_to('admin/users', 'activate')
      # invalidate forgeos_people(:user) record
      forgeos_people(:user).email = ''
      forgeos_people(:user).save(:validate => false)
      @request.env['HTTP_REFERER'] = 'http://test.host/admin/users'
      put :activate, :id => forgeos_people(:user).id, :use_route => :forgeos_core

      assert_equal forgeos_people(:user), assigns(:user)
      assert forgeos_people(:user).reload.active?
      assert_not_nil flash[:error]
      assert_redirected_to '/admin/users'
    end

    test "should not put activate with unactive user" do
      admin_login_to('admin/users', 'activate')
      # invalidate forgeos_people(:user) record
      forgeos_people(:user).email = ''
      forgeos_people(:user).active = false
      forgeos_people(:user).save(:validate => false)
      @request.env['HTTP_REFERER'] = 'http://test.host/admin/users'
      put :activate, :id => forgeos_people(:user).id, :use_route => :forgeos_core

      assert_equal forgeos_people(:user), assigns(:user)
      assert !forgeos_people(:user).reload.active?
      assert_not_nil flash[:error]
      assert_redirected_to '/admin/users'
    end

    ####################################
    # Testing export_newsletter method #
    ####################################

    test "should get export_newsletter" do
      admin_login_to('admin/users', 'export_newsletter')
      get :export_newsletter, :use_route => :forgeos_core
      assert_response :success
      assert_equal 'text/plain', @response.headers['Content-Type']
      assert_match 'john.doe@forgeos.com', @response.body
    end
  end
end
