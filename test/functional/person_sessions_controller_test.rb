require 'test_helper'

class PersonSessionsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "should get new" do
    get :new, :use_route => :forgeos_core
    assert_kind_of PersonSession, assigns(:person_session)
  end

  test "should delete destroy without logged user" do
    delete :destroy, :use_route => :forgeos_core
    assert_redirected_to '/'
  end


  test "should delete destroy with logged user" do
    PersonSession.create(people(:user))

    delete :destroy, :use_route => :forgeos_core
    assert_redirected_to '/'
    assert_nil PersonSession.find
  end

  test "should post create" do
    post :create, :use_route => :forgeos_core
    assert_kind_of PersonSession, assigns(:person_session)
    assert_not_nil flash[:error]
    assert_redirected_to '/login'

    post :create, :person_session => { :email => people(:user).email, :password => 'admin'}, :use_route => :forgeos_core
    assert_not_nil flash[:notice]
    assert_redirected_to '/'

    session[:return_to] = '/test'
    post :create, :person_session => { :email => people(:user).email, :password => 'admin'}, :use_route => :forgeos_core
    assert_redirected_to '/test'
  end
end
