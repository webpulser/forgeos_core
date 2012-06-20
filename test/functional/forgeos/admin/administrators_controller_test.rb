require 'test_helper'

module Forgeos
  class Admin::AdministratorsControllerTest < ActionController::TestCase
    setup :activate_authlogic

    test "should be the current tab" do
      admin_login_to('admin/administrators', 'index')
      @request.path = '/admin/administrators' # fix ActionController::TestCase request path is '/'
      get :index, :use_route => :forgeos_core
      assert_select 'ul.nav' do
        assert_select 'li.active a', 'administrators'
        assert_select 'li.active a i.icon-user-md', true
      end
    end

    test "should be the current menu entry" do
      admin_login_to('admin/administrators', 'index')
      @request.path = '/admin/administrators' # fix ActionController::TestCase request path is '/'
      get :index, :use_route => :forgeos_core
      assert_select '#submenu' do
        assert_select 'li.active a', 'administrators'
      end
    end

    #########################
    # Testing index method  #
    #########################
    test "should get index as html" do
      admin_login_to('admin/administrators', 'index')
      get :index, :use_route => :forgeos_core
      assert_response :success
    end

    test "should get index as json" do
      admin_login_to('admin/administrators', 'index')
      get :index, :format => 'json', :sEcho => 0, :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalDisplayRecords\":1/, @response.body
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match /\"sEcho\":0/, @response.body
      assert_match 'admin@forgeos.com', @response.body
    end

    test "should get index as json with category_id" do
      admin_login_to('admin/administrators', 'index')
      get :index, :format => 'json', :sEcho => 0, :use_route => :forgeos_core, :category_id => 1
      assert_response :success
      assert_match /\"iTotalDisplayRecords\":0/, @response.body
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match /\"sEcho\":0/, @response.body
    end

    test "should get index as json with ids" do
      admin_login_to('admin/administrators', 'index')
      get :index, :format => 'json', :sEcho => 0, :use_route => :forgeos_core, :ids => [forgeos_people(:administrator).id]
      assert_response :success
      assert_match /\"iTotalDisplayRecords\":1/, @response.body
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match /\"sEcho\":0/, @response.body
      assert_match 'admin@forgeos.com', @response.body
    end

    test "should get index as json with sorting by id" do
      admin_login_to('admin/administrators', 'index')
      get :index, :format => 'json', :sEcho => 0, :iSortCol_0 => 0, :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match 'admin@forgeos.com', @response.body
    end

    test "should get index as json with sorting by full_name" do
      admin_login_to('admin/administrators', 'index')
      get :index, :format => 'json', :sEcho => 0, :iSortCol_0 => 1, :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match 'admin@forgeos.com', @response.body
    end

    test "should get index as json with sorting by email" do
      admin_login_to('admin/administrators', 'index')
      get :index, :format => 'json', :sEcho => 0, :iSortCol_0 => 2, :sSortDir_0 => 'DESC', :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match 'admin@forgeos.com', @response.body
    end

    test "should get index as json with sorting by active" do
      admin_login_to('admin/administrators', 'index')
      get :index, :format => 'json', :sEcho => 0, :iSortCol_0 => 3, :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match 'admin@forgeos.com', @response.body
    end

    test "should get index as json to search admin" do
      admin_login_to('admin/administrators', 'index')
      get :index, :format => 'json', :sEcho => 0, :sSearch => 'admin', :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match /\"iTotalDisplayRecords\":1/, @response.body
      assert_match 'admin@forgeos.com', @response.body
    end

    test "should get index as json to search by id" do
      admin_login_to('admin/administrators', 'index')
      get :index, :format => 'json', :sEcho => 0, :sSearch => "##{forgeos_people(:administrator).id}", :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match /\"iTotalDisplayRecords\":1/, @response.body
      assert_match 'admin@forgeos.com', @response.body
    end

    test "should get index as json to search nothing with sorting by id" do
      admin_login_to('admin/administrators', 'index')
      get :index, :format => 'json', :sSearch => 'nothing', :sEcho => 0, :iSortCol_0 => 0, :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match /\"iTotalDisplayRecords\":0/, @response.body
      assert !@response.body.include?('admin@fogeos.com')
    end

    test "should get index as json to search admin with sorting by full_name" do
      admin_login_to('admin/administrators', 'index')
      get :index, :format => 'json', :sSearch => 'admin', :sEcho => 0, :iSortCol_0 => 1, :use_route => :forgeos_core
      assert_response :success
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match /\"iTotalDisplayRecords\":1/, @response.body
      assert_match 'admin@forgeos.com', @response.body
    end

    #########################
    #  Testing show method  #
    #########################

    test "should get show" do
      admin_login_to('admin/administrators','show')
      get :show, :id => forgeos_people(:administrator).id, :use_route => :forgeos_core
      assert_response :success
      assert_equal forgeos_people(:administrator), assigns(:administrator)
      assert_template 'admin/administrators/show'
    end

    test "should not get show" do
      admin_login_to('admin/administrators','show')
      get :show, :id => 0, :use_route => :forgeos_core
      assert_redirected_to '/admin/administrators'
      assert_not_nil flash[:alert]
    end

    #########################
    #  Testing edit method  #
    #########################

    test "should get edit" do
      admin_login_to('admin/administrators', 'edit')
      get :edit, :id => forgeos_people(:administrator).id, :use_route => :forgeos_core
      assert_response :success
      assert_equal forgeos_people(:administrator), assigns(:administrator)
      assert_template 'admin/administrators/edit'
      assert_template 'admin/administrators/_form'
    end

    test "should not get edit" do
      admin_login_to('admin/administrators','edit')
      get :edit, :id => 0, :use_route => :forgeos_core
      assert_redirected_to '/admin/administrators'
      assert_not_nil flash[:alert]
    end

    #########################
    #  Testing new method   #
    #########################

    test "should get new" do
      admin_login_to('admin/administrators', 'new')
      get :new, :use_route => :forgeos_core
      assert_response :success
      assert assigns(:administrator).new_record?, "administrator is not a new record"
      assert_template 'admin/administrators/new'
      assert_template 'admin/administrators/_form'
    end

    test "should get new with params" do
      admin_login_to('admin/administrators', 'new')
      get :new, :administrator => { :lastname => 'test' },:use_route => :forgeos_core
      assert_response :success
      assert assigns(:administrator).new_record?, "administrator is not a new record"
      assert_equal 'test', assigns(:administrator).lastname
    end

    #########################
    # Testing create method #
    #########################

    test "should post create" do
      admin_login_to('admin/administrators', 'create')
      assert_difference 'Administrator.count', 1 do
        post :create, :administrator => {
          :lastname => 'test',
          :firstname => 'test',
          :email => 'test@forgeos.com',
          :password => 'forgeos',
          :password_confirmation => 'forgeos'
        }, :use_route => :forgeos_core
      end

      assert_redirected_to "/admin/administrators/#{assigns(:administrator).id}"
      assert !assigns(:administrator).new_record?, "administrator not saved"
      assert_equal 'test', assigns(:administrator).lastname
    end

    test "should post create with invalid record" do
      admin_login_to('admin/administrators', 'create')
      assert_no_difference 'Administrator.count', 1 do
        post :create, :administrator => {
          :lastname => 'test',
          :firstname => 'test'
        }, :use_route => :forgeos_core
      end

      assert_response :success
      assert !assigns(:administrator).valid?, "administrator is valid and should not be"
      assert assigns(:administrator).new_record?, "administrator is not a new record"
      assert_equal 'test', assigns(:administrator).lastname
      assert_template 'admin/administrators/new'
      assert_not_nil flash[:alert]
    end

    #########################
    # Testing update method #
    #########################

    test "should put update" do
      admin_login_to('admin/administrators', 'update')
      put :update, :id => forgeos_people(:administrator).id, :administrator => {
        :lastname => 'test',
        :firstname => 'test',
        :email => 'test@forgeos.com',
        :password => 'forgeos',
        :password_confirmation => 'forgeos'
      }, :use_route => :forgeos_core

      assert_equal forgeos_people(:administrator), assigns(:administrator)
      assert_equal 'test', forgeos_people(:administrator).reload.lastname
      assert_redirected_to "/admin/administrators/#{assigns(:administrator).id}"
    end

    test "should put update with invalid record" do
      admin_login_to('admin/administrators', 'update')
      put :update, :id => forgeos_people(:administrator).id, :administrator => {
        :lastname => 'test',
        :email => ''
      }, :use_route => :forgeos_core

      assert_response :success
      assert_equal forgeos_people(:administrator), assigns(:administrator)
      assert !assigns(:administrator).valid?, "administrator is valid and should not be"
      assert_not_equal 'test', forgeos_people(:administrator).reload.lastname
      assert_template 'admin/administrators/edit'
    end

    ##########################
    # Testing destroy method #
    ##########################

    test "should delete destroy" do
      admin_login_to('admin/administrators', 'destroy')
      assert_difference 'Administrator.count', -1 do
        delete :destroy, :id => forgeos_people(:administrator).id, :use_route => :forgeos_core
      end

      assert_redirected_to '/admin/administrators'
    end

    test "should delete destroy in js" do
      admin_login_to('admin/administrators', 'destroy')
      assert_difference 'Administrator.count', -1 do
        delete :destroy, :format => 'js', :id => forgeos_people(:administrator).id, :use_route => :forgeos_core
      end

      assert_response :success
    end

    test "should not delete destroy" do
      Administrator.class_eval do
        before_destroy do
          return false
        end
      end

      admin_login_to('admin/administrators', 'destroy')
      assert_no_difference 'Administrator.count', -1 do
        delete :destroy, :id => forgeos_people(:administrator).id, :use_route => :forgeos_core
      end

      assert_redirected_to '/admin/administrators'
      assert_not_nil flash[:alert]
    end

    test "should not delete destroy in js" do
      Administrator.class_eval do
        before_destroy do
          return false
        end
      end

      admin_login_to('admin/administrators', 'destroy')
      assert_no_difference 'Administrator.count', -1 do
        delete :destroy, :format => 'js', :id => forgeos_people(:administrator).id, :use_route => :forgeos_core
      end

      assert_response :success
      assert_not_nil flash[:alert]
    end

    ###########################
    # Testing activate method #
    ###########################

    test "should put activate with active administrator" do
      admin_login_to('admin/administrators', 'activate')
      @request.env['HTTP_REFERER'] = 'http://test.host/admin/administrators'
      put :activate, :id => forgeos_people(:administrator).id, :use_route => :forgeos_core

      assert_equal forgeos_people(:administrator), assigns(:administrator)
      assert !forgeos_people(:administrator).reload.active?
      assert_redirected_to '/admin/administrators'
    end

    test "should not put activate with active administrator" do
      admin_login_to('admin/administrators', 'activate')
      # invalidate forgeos_people(:administrator) record
      forgeos_people(:administrator).email = ''
      forgeos_people(:administrator).save(:validate => false)
      @request.env['HTTP_REFERER'] = 'http://test.host/admin/administrators'
      put :activate, :id => forgeos_people(:administrator).id, :use_route => :forgeos_core

      assert_equal forgeos_people(:administrator), assigns(:administrator)
      assert forgeos_people(:administrator).reload.active?
      assert_not_nil flash[:alert]
      assert_redirected_to '/admin/administrators'
    end
  end
end
