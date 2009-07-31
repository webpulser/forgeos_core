require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::AdminsController, "GET index" do
  should_require_admin_login :get, :index
  
  describe "admin admin" do
    before(:each) do
      login_as_admin
      Admin.stub!(:all).and_return @admins
    end

    it "should load all admins" do
      Admin.should_receive(:all)
      get :index
    end
    
    it "should assign @admins" do
      get :index
      assigns[:admins].should == @admins
    end
    
    it "should render the index template" do
      get :index
      response.should render_template("index")
    end
  end
end

describe Admin::AdminsController, "GET show" do
  should_require_admin_login :get, :index

  describe "admin admin" do
    before :each do
      login_as_admin
      @admin = mock_model(Admin, :null_object => true)
      Admin.stub!(:find_by_id).and_return @admin
    end

    it "should load the required admin" do
      Admin.should_receive(:find_by_id).with("1")
      get :show, :id => 1
    end
  
    it "should assign @admin" do
      get :show
      assigns[:admin].should == @admin
    end
    
    it "should render the show template" do
      get :show
      response.should render_template("show")
    end

    context "when admin does not exist" do
      before(:each) do
        Admin.stub!(:find_by_id).and_return nil
      end

      it "should put a message in flash[:error]" do
        get :show
        flash[:error].should_not == nil
      end
    end
  end
end

describe Admin::AdminsController, "GET new" do
  describe "admin admin" do 
    before(:each) do
      login_as_admin
      Admin.stub!(:new).and_return @admin
    end

    it "should load the required admin" do
      Admin.should_receive(:new).and_return(@admin)
      get :new
    end
    
    it "should assign @admin" do
      get :new
      assigns[:admin].should == @admin
    end
    
    it "should render the new template" do
      get :new
      response.should render_template("new")
    end
  end
end

describe Admin::AdminsController, "GET edit" do
  should_require_admin_login :get, :edit

  describe "admin admin" do
  
    before(:each) do
      login_as_admin
      @admin = mock_model(Admin, :save => nil)
      Admin.stub!(:find_by_id).and_return @admin
      @admin.stub!(:user).and_return @user
    end

    it "should load the required admin" do
      Admin.should_receive(:find_by_id).with("1")
      get :edit, :id => 1
    end
    
    it "should assign @admin" do
      get :edit
      assigns[:admin].should == @admin
    end
    
    it "should render the edit template" do
      get :edit
      response.should render_template("edit")
    end

    context "when admin does not exist" do
      before(:each) do
        Admin.stub!(:find_by_id).and_return nil
      end

      it "should put a message in flash[:error]" do
        get :edit
        flash[:error].should_not == nil
      end
    end
  end
end

describe Admin::AdminsController, "POST create" do
  should_require_admin_login :post, :create
  
  describe "admin admin" do
  
    before(:each) do
      login_as_admin

      @role = Role.create
      @rights = []
      3.times { @rights << Right.create() }

#      @admin = mock_model(Admin, :save => nil)
      @admin = Admin.new
      @avatar = mock_model(Picture, :save => nil)
      Admin.stub!(:new).and_return @admin

      # avatar file to upload
      @uploader = uploaded_file('rails.png')
    end

    it "should build a new admin" do
      Admin.should_receive(:new).with('firstname' => 'John', 'lastname' => 'Doe', 'email' => 'john.doe@company.com', 'password' => 'johndoe', 'password_confirmation' => 'johndoe', 'role_ids' => ['1'], 'right_ids' => ['1', '2', '3']).and_return(@admin)
      post :create, :admin => {'firstname' => 'John', 'lastname' => 'Doe', 'email' => 'john.doe@company.com', 'password' => 'johndoe', 'password_confirmation' => 'johndoe', 'role_ids' => ['1'], 'right_ids' => ['1', '2', '3']}
    end
	
    it "should save the admin" do
      @admin.should_receive(:save)
      post :create, :admin => {'firstname' => 'John', 'lastname' => 'Doe', 'email' => 'john.doe@company.com', 'password' => 'johndoe', 'password_confirmation' => 'johndoe', 'role_ids' => [@role.id], 'right_ids' => @rights.collect{ |right| right.id}}, :avatar => {:uploaded_data => @uploader}
    end
    
    context "when the admin saves successfully" do
      before :each do
        @admin.stub!(:save).and_return true
        @admin.stub!(:id).and_return 1
      end

      it "should set a flash[:notice] message" do
        post :create, :admin => {'firstname' => 'John', 'lastname' => 'Doe', 'email' => 'john.doe@company.com', 'password' => 'johndoe', 'password_confirmation' => 'johndoe', 'role_ids' => [@role.id], 'right_ids' => @rights.collect{ |right| right.id}}, :avatar => {:uploaded_data => @uploader}       
        flash[:notice].should_not == nil
      end
      
      it "should redirect to the admins index" do
        post :create, :admin => {'firstname' => 'John', 'lastname' => 'Doe', 'email' => 'john.doe@company.com', 'password' => 'johndoe', 'password_confirmation' => 'johndoe', 'role_ids' => [@role.id], 'right_ids' => @rights.collect{ |right| right.id}}, :avatar => {:uploaded_data => @uploader}
        response.should redirect_to(admin_admins_path)
      end
    end
    
    context "when the admin fails to save" do
      before(:each) do
        @admin.stub!(:save).and_return false
      end

      it "should assign @admin" do
        post :create, :admin => {}
        assigns[:admin].should == @admin
      end
      
      it "should put a message in flash[:error]" do
        post :create, :admin => {}
        flash[:error].should_not == nil
      end
      
      it "should render the new template" do
        post :create, :admin => {}
        response.should render_template("new")
      end
    end
  end
end

# TODO !
# describe Admin::AdminsController, "PUT update" do
#   should_require_admin_login :put, :update
  
#   describe "admin admin" do
#     before(:each) do
#       login_as_admin
# 			@user = mock_model(User, :null_object => true)
#       @admin = mock_model(Admin, :save => nil)
#       @admin.stub!(:user).and_return @user
#       Admin.stub!(:find_by_id).and_return @admin
#     end
    
#     context "when the admin saves successfully" do
#       before(:each) do
#         @admin.stub!(:update_attributes).and_return true
#       end

#       it "should load the required admin" do
#         Admin.should_receive(:find_by_id).with("1").and_return @admin
#         put :update, :id => 1, :admin => {}
#       end

#       it "should save the admin" do
#         @admin.should_receive(:update_attributes).with('name' => 'new_webpulser', 'active' => '0', 'competitors_option' => '0', 'user' => @admin.user).and_return(true)
#         put :update, :admin => { :name => 'new_webpulser', :active => '0', :competitors_option => '0' }
#       end
      
#       it "should set a flash[:notice] message" do
#         put :update, :admin => {}
#         flash[:notice].should == "The admin was successfully updated"
#       end
      
#       it "should redirect to the admins index" do
#         put :update, :admin => {}
#         response.should redirect_to(admin_admins_path)
#       end
#     end

#     context "when the admin does not exist" do
#       before(:each) do
#         Admin.stub!(:find_by_id).and_return nil
#       end

#       it "should put a message in flash[:error]" do
#         put :update
#         flash[:error].should == "Admin does not exist"
#       end

#       it "should redirect to the admins index" do
#         put :update
#         response.should redirect_to(admin_admins_path)
#       end
#     end
    
#     context "when the admin fails to save" do
#       before(:each) do
#         @admin.stub!(:update_attributes).and_return false
#       end
      
#       it "should assign @admin" do
#         put :update, :admin => {}
#         assigns[:admin].should == @admin
#       end

#       it "should put a message in flash[:error]" do
#         put :update, :admin => {}
#         flash[:error].should == "A problem occurred during the admin update"
#       end
      
#       it "should render the edit template" do
#         put :update, :admin => {}
#         response.should render_template("edit")
#       end
#     end
#   end
# end

describe Admin::AdminsController, "DELETE destroy" do
  should_require_admin_login :delete, :destroy

  describe "admin admin" do
    before(:each) do
      login_as_admin
      @admin = mock_model(Admin, :save => nil)
      Admin.stub!(:find_by_id).and_return @admin
    end
    
    context "when the admin is successfully deleted" do
      before(:each) do
        @admin.stub!(:destroy).and_return true
      end

      it "should load the required admin" do
        Admin.should_receive(:find_by_id).with("1")
        delete :destroy, :id => 1
      end

      it "should delete the admin" do
        @admin.should_receive(:destroy)
        delete :destroy
      end
      
      it "should set a flash[:notice] message" do
        delete :destroy
        flash[:notice].should_not == nil
      end
      
      it "should redirect to the admins index" do
        delete :destroy
        response.should redirect_to(admin_admins_path)
      end
    end

    context "when admin does not exist" do
      before(:each) do
        Admin.stub!(:find_by_id).and_return nil
      end

      it "should put a message in flash[:error]" do
        delete :destroy
        flash[:error].should_not == nil
      end

      it "should redirect to the admins index" do
        delete :destroy
        response.should redirect_to(admin_admins_path)
      end
    end
    
    context "when the admin fails to delete" do
      before(:each) do
        @admin.stub!(:destroy).and_return false
      end
      
      it "should assign @admin" do
        delete :destroy
        assigns[:admin].should == @admin
      end

      it "should put a message in flash[:error]" do
        delete :destroy
        flash[:error].should_not == nil
      end
      
      it "should render the show template" do
        delete :destroy
        response.should redirect_to(admin_admins_path)
      end
    end
  end
end
