require 'test_helper'

class MenuHelperTest < ActionView::TestCase
  include Forgeos::MenuHelper

  attr_accessor :controller, :request
  setup :_prepare_context

  def request_for_url(url, opts = {})
    env = Rack::MockRequest.env_for("http://www.example.com#{url}", opts)
    ActionDispatch::Request.new(env)
  end

  test "should detect current_path" do
    # same path
    assert current_path?('/admin', '/admin'), "doesn't detect same path"

    # inherited path
    assert current_path?('/directory', '/directory/subdirectory'), "doesn't detect subpath"

    # hash path
    assert current_path?('/directory', {:controller => 'directory', :action => 'show', :id => 'test'}), "doesn't detect hash path"

    # named path
    assert current_path?('/directory', current_path_detection_path('test')), "doesn't detect named path"

    # request based path
    @request = request_for_url('/directory/1/edit')
    assert current_path?('/directory'), "doesn't detect request based path"
  end

  test "should generate a menu" do
    build_menu({:menu => { :toto => 'toto'}})
    assert_not_nil content_for(:menu)
  end

  test "should generate a menu item" do
    @request = request_for_url('/')
    assert_match /li/, menu_item({ :url => '/toto' }, :toto)
  end

  test "should generate a menu item with Hash children" do
    @request = request_for_url('/')
    assert_match /li/, menu_item({ :url => '/toto', :children => { :titi => 'titi', :tata => 'tata' } }, :toto)
  end

  test "should generate a menu item with Hash and strings children" do
    @request = request_for_url('/')
    assert_match /li/, menu_item({ :url => '/toto', :children => { :titi => 'titi' } }, :toto)
  end

  test "should generate a menu item with Hash and hashs children" do
    @request = request_for_url('/')
    assert_match /li/, menu_item({ :url => '/toto', :children => { :titi => { :url => 'titi' } } }, :toto)
  end

  test "should generate a menu item with Hash and array children" do
    @request = request_for_url('/')
    assert_match /li/, menu_item({ :url => '/toto', :children => { :titi => ['titi1', 'titi2'] } }, :toto)
  end

end
