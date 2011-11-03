require 'test_helper'

class Admin::BaseHelperTest < ActionView::TestCase
  include Forgeos::Admin::BaseHelper

  test "should display submit_tag" do
    output = fg_submit_tag(:forgeos)
    assert_match /<input/, output
    assert_match /class="backgrounds interact-button"/, output
    assert_match /Forgeos core/, output
    assert_match /type="submit"/, output
  end

  test "should generate polymorphic html id" do
    output = polymorphic_html_id(people(:user))
    assert_equal "user_#{people(:user).id}", output
  end

  test "should generate polymorphic html id with prefix" do
    output = polymorphic_html_id(people(:user), 'prefix')
    assert_equal "prefix_user_#{people(:user).id}", output
  end


  test "should display save buttons" do
    output = forgeos_save_buttons('/admin')
    assert_match /<div class="interact-links">/, output
    assert_match /or/, output
    assert_match /class="back-link"/, output
    assert_match /type="submit"/, output
    assert_match /href="\/admin"/, output
  end

  test "should init datatable" do
    output = dataTables_tag(:id => 'test', :url => '/admin', :columns => ['toto', 'tata'])
    assert_match /javascript/, output
    assert_match /dataTable\(/, output
    assert_match /jQuery\('#test'\)/, output
  end

  test "should init dataslide" do
    output = dataSlides_tag(:id => 'test', :url => '/admin', :columns => ['toto', 'tata'])
    assert_match /javascript/, output
    assert_match /dataSlide\(/, output
    assert_match /jQuery\('#test'\)/, output
  end

end
