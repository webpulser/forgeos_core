require 'test_helper'

module Forgeos
  class Admin::BaseHelperTest < ActionView::TestCase
    include Forgeos::Admin::BaseHelper

    test "should display submit_tag" do
      output = fg_submit_tag(:forgeos_core)
      assert_match /<button/, output
      assert_match /class="btn btn-large btn-primary"/, output
      assert_match /Forgeos core/i, output
      assert_match /type="submit"/, output
    end

    test "should generate polymorphic html id" do
      output = polymorphic_html_id(forgeos_people(:user))
      assert_equal "user_#{forgeos_people(:user).id}", output
    end

    test "should generate polymorphic html id with prefix" do
      output = polymorphic_html_id(forgeos_people(:user), 'prefix')
      assert_equal "prefix_user_#{forgeos_people(:user).id}", output
    end


    test "should display save buttons" do
      output = forgeos_save_buttons('/admin')
      assert_match /<button/, output
      assert_match /class="btn btn-large btn-primary"/, output
      assert_match /class="btn btn-mini"/, output
      assert_match /type="submit"/, output
      assert_match /href="\/admin"/, output
    end
  end
end
