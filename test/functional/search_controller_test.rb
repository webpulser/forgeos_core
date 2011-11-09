require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, :use_route => :forgeos_core
    assert_response :success
  end

  test "should get index with a new keyword" do
    assert_difference 'SearchKeywordCounter.count', 1 do
      assert_difference 'SearchKeyword.count', 1 do
        get :index, :keywords => 'test', :use_route => :forgeos_core
      end
    end

    assert 'test', assigns(:keywords)
    assert_not_nil assigns(:search_keyword)
    assert_response :success
  end

  test "should get index with an existing keyword" do
    SearchKeyword.create(:keyword => 'test')
    assert_difference 'SearchKeywordCounter.count', 1 do
      assert_no_difference 'SearchKeyword.count', 1 do
        get :index, :keywords => 'test', :use_route => :forgeos_core
      end
    end

    assert_response :success
  end

end
