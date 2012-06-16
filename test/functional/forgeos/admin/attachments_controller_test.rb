require 'test_helper'

module Forgeos
  class Admin::AttachmentsControllerTest < ActionController::TestCase
    setup :activate_authlogic

    #########################
    # Testing index method  #
    #########################
    test "should get index as html" do
      admin_login_to('admin/attachments', 'index')
      get :index, :use_route => :forgeos_core
      assert_response :success
    end

    test "should get index as json with klass" do
      admin_login_to('admin/attachments', 'index')
      get :index, :use_route => :forgeos_core, :format => :json, :klass => 'forgeos::Picture'
      assert_response :success
      assert_equal Forgeos::Picture, assigns(:attachment_class)
      assert_equal 'picture', assigns(:file_type)
    end

    test "should get index as json without klass" do
      admin_login_to('admin/attachments', 'index')
      get :index, :use_route => :forgeos_core, :format => :json
      assert_response :success
      assert_equal Forgeos::Medium, assigns(:attachment_class)
      assert_equal 'medium', assigns(:file_type)
    end

    test "should get index as json with bad klass" do
      admin_login_to('admin/attachments', 'index')
      get :index, :use_route => :forgeos_core, :format => :json, :klass => 'Nothing'
      assert_redirected_to '/admin/library'
      assert_not_nil flash[:error]
    end

    test "should get index as json with ids" do
      admin_login_to('admin/attachments', 'index')
      get :index, :format => 'json', :sEcho => 0, :use_route => :forgeos_core, :ids => [forgeos_attachments(:picture).id], :klass => 'Forgeos::Picture'
      assert_response :success
      assert_match /\"iTotalDisplayRecords\":1/, @response.body
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match /\"sEcho\":0/, @response.body
      assert_match 'picture', @response.body
    end

    test "should get index as json with sorting by id" do
      admin_login_to('admin/attachments', 'index')
      get :index, :format => 'json', :sEcho => 0, :iSortCol_0 => 0, :use_route => :forgeos_core, :klass => 'Forgeos::Doc'
      assert_response :success
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match 'doc', @response.body
    end

    test "should get index as json with sorting by filename" do
      admin_login_to('admin/attachments', 'index')
      get :index, :format => 'json', :sEcho => 0, :iSortCol_0 => 1, :sSortDir_0 => 'DESC', :use_route => :forgeos_core, :klass => 'Forgeos::Video'
      assert_response :success
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match 'video', @response.body
    end

    test "should get index as json to search audio" do
      admin_login_to('admin/attachments', 'index')
      get :index, :format => 'json', :sEcho => 0, :sSearch => 'audio', :use_route => :forgeos_core, :klass => 'Forgeos::Audio'
      assert_response :success
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match /\"iTotalDisplayRecords\":1/, @response.body
      assert_match 'audio', @response.body
    end

    test "should get index as json to search by id" do
      admin_login_to('admin/attachments', 'index')
      get :index, :format => 'json', :sEcho => 0, :sSearch => "##{forgeos_attachments(:picture).id}", :use_route => :forgeos_core, :klass => 'Forgeos::Picture'
      assert_response :success
      assert_match /\"iTotalRecords\":1/, @response.body
      assert_match /\"iTotalDisplayRecords\":1/, @response.body
      assert_match 'picture', @response.body
    end

    #########################
    #  Testing show method  #
    #########################

    test "should get show" do
      admin_login_to('admin/attachments', 'show')
      get :show, :id => forgeos_attachments(:picture).id, :use_route => :forgeos_core
      assert_response :success
      assert_equal forgeos_attachments(:picture), assigns(:attachment)
      assert_template 'admin/attachments/show'
      assert_template 'admin/attachments/_picture'
    end

    test "should not get show" do
      admin_login_to('admin/attachments','show')
      get :show, :id => 0, :use_route => :forgeos_core
      assert_redirected_to '/admin/library'
      assert_not_nil flash[:error]
    end

    #########################
    #  Testing edit method  #
    #########################

    test "should get edit" do
      admin_login_to('admin/attachments', 'edit')
      get :edit, :id => forgeos_attachments(:picture).id, :use_route => :forgeos_core
      assert_response :success
      assert_equal forgeos_attachments(:picture), assigns(:attachment)
      assert_template 'admin/attachments/edit'
      assert_template 'admin/attachments/_form'
    end

    test "should not get edit" do
      admin_login_to('admin/attachments','edit')
      get :edit, :id => 0, :use_route => :forgeos_core
      assert_redirected_to '/admin/library'
      assert_not_nil flash[:error]
    end

    #########################
    # Testing create method #
    #########################

    test "should post create" do
      admin_login_to('admin/attachments', 'create')
      assert_difference 'Attachment.count', 1 do
        post :create, :Filedata => Rack::Test::UploadedFile.new(File.expand_path('../../../../files/rails.png', __FILE__)), :use_route => :forgeos_core, :format => :json, :klass => 'Forgeos::Picture'
      end

      assert_response :success
      assert !assigns(:attachment).new_record?, "media not saved"
      assert_match '"result":"success"', @response.body
      assert_match "\"id\":#{assigns(:attachment).id}", @response.body
    end

    test "should post create with category" do
      category = PictureCategory.create(:name => 'photos')
      admin_login_to('admin/attachments', 'create')
      assert_difference 'Attachment.count', 1 do
        post :create, :Filedata => Rack::Test::UploadedFile.new(File.expand_path('../../../../files/rails.png', __FILE__)), :use_route => :forgeos_core, :format => :json, :klass => 'Forgeos::Picture', :parent_id => category.id
      end

      assert_response :success
      assert !assigns(:attachment).new_record?, "media not saved"
      assert_match '"result":"success"', @response.body
      assert_match "\"id\":#{assigns(:attachment).id}", @response.body
      assert_equal 1, category.reload.elements.count
    end

    test "should post create assiotiated object" do
      object = Category.create(:name => 'photos')
      admin_login_to('admin/attachments', 'create')
      assert_difference 'Attachment.count', 1 do
        post :create, :Filedata => Rack::Test::UploadedFile.new(File.expand_path('../../../../files/rails.png', __FILE__)), :use_route => :forgeos_core, :format => :json, :klass => 'Forgeos::Picture', :target_id => object.id, :target => object.class.to_s
      end

      assert_response :success
      assert !assigns(:attachment).new_record?, "media not saved"
      assert_match '"result":"success"', @response.body
      assert_match "\"id\":#{assigns(:attachment).id}", @response.body
      assert_equal 1, object.reload.attachments.count
    end

    test "should post create with invalid record" do
      admin_login_to('admin/attachments', 'create')
      assert_no_difference 'Attachment.count', 1 do
        post :create, :Filedata => nil, :attachment => { :filename => nil }, :use_route => :forgeos_core, :format => :json
      end

      assert_response :success
      assert !assigns(:attachment).valid?, "media is valid and should not be"
      assert assigns(:attachment).new_record?, "media is not a new record"
      assert_match '"result":"error"', @response.body
    end

    test "should post create in js" do
      admin_login_to('admin/attachments', 'create')
      assert_difference 'Attachment.count', 1 do
        post :create, :Filedata => Rack::Test::UploadedFile.new(File.expand_path('../../../../files/rails.png', __FILE__)), :use_route => :forgeos_core, :format => :js, :klass => 'Forgeos::Picture'
      end

      assert !assigns(:attachment).new_record?, "media not saved"
      assert_response :success
    end

    test "should post create with invalid record in js" do
      admin_login_to('admin/attachments', 'create')
      assert_no_difference 'Attachment.count', 1 do
        post :create, :Filedata => nil, :use_route => :forgeos_core, :format => :js
      end

      assert_response :success
      assert !assigns(:attachment).valid?, "media is valid and should not be"
    end
    #########################
    # Testing update method #
    #########################

    test "should put update" do
      admin_login_to('admin/attachments', 'update')
      put :update, :id => forgeos_attachments(:picture).id, :attachment => {
        :name => 'test',
      }, :use_route => :forgeos_core, :klass => 'Forgeos::Picutre'

      assert_response :success
      assert_equal forgeos_attachments(:picture), assigns(:attachment)
      assert_equal 'test', forgeos_attachments(:picture).reload.name
      assert_template 'admin/attachments/edit'
    end

    test "should put update with invalid record" do
      admin_login_to('admin/attachments', 'update')
      put :update, :id => forgeos_attachments(:picture).id, :attachment => {
        :filename => nil,
        :content_type => 'none'
      }, :use_route => :forgeos_core, :klass => 'Forgeos::Picture'

      assert_response :success
      assert_equal forgeos_attachments(:picture), assigns(:attachment)
      assert !assigns(:attachment).valid?, "media is valid and should not be"
      assert_not_equal 'none', forgeos_attachments(:picture).reload.content_type
      assert_template 'admin/attachments/edit'
    end

    ##########################
    # Testing destroy method #
    ##########################

    test "should delete destroy" do
      admin_login_to('admin/attachments', 'destroy')
      assert_difference 'Attachment.count', -1 do
        delete :destroy, :id => forgeos_attachments(:audio).id, :use_route => :forgeos_core
      end

      assert_redirected_to '/admin/audios'
    end

    test "should delete destroy in js" do
      admin_login_to('admin/attachments', 'destroy')
      assert_difference 'Attachment.count', -1 do
        delete :destroy, :format => 'js', :id => forgeos_attachments(:audio).id, :use_route => :forgeos_core
      end

      assert_response :success
      assert_equal 'text/javascript; charset=utf-8', @response.headers['Content-Type']
    end

    test "should not delete destroy" do
      Attachment.class_eval do
        before_destroy do
          return false
        end
      end

      admin_login_to('admin/attachments', 'destroy')
      assert_no_difference 'Attachment.count', -1 do
        delete :destroy, :id => forgeos_attachments(:audio).id, :use_route => :forgeos_core
      end

      assert_redirected_to '/admin/audios'
      assert_not_nil flash[:error]
    end

    test "should not delete destroy in js" do
      Attachment.class_eval do
        before_destroy do
          return false
        end
      end

      admin_login_to('admin/attachments', 'destroy')
      assert_no_difference 'Attachment.count', -1 do
        delete :destroy, :format => 'js', :id => forgeos_attachments(:audio).id, :use_route => :forgeos_core
      end

      assert_response :success
      assert_not_nil flash[:error]
    end

    ###########################
    # Testing download method #
    ###########################

    test "should get download" do
      admin_login_to('admin/attachments', 'download')
      get :download, :id => forgeos_attachments(:picture).id, :use_route => :forgeos_core

      assert_response :success
      assert_equal forgeos_attachments(:picture).content_type, @response.headers['Content-Type']
    end

    ###########################
    # Testing manage method #
    ###########################

    test "should get manage" do
      admin_login_to('admin/attachments', 'manage')
      get :manage, :use_route => :forgeos_core, :klass => 'Forgeos::Picture'

      assert_response :success
      assert_not_nil assigns(:attachments)
    end
  end
end
