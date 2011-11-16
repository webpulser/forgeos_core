require 'test_helper'

module Forgeos
  class ErrorFieldsTest < ActionView::TestCase
    test "should return html_tag if no error" do
      assert_equal "<input type='text'>", ActionView::Base.field_error_proc.call("<input type='text'>", generate_instance_tag)
    end

    test "should append a div with classes 'field error' to html_tag" do
      html_tag = generate_invalid_tag("<input type='text'>")

      assert_match /<input type='text'>/, html_tag
      assert_match /<div class='field error'/, html_tag
    end

    test "should return html_tag if is an hidden field" do
      assert_equal "<input type='hidden' />", generate_invalid_tag("<input type='hidden' />")
    end

    test "should return html_tag if is a label" do
      assert_equal "<label>", generate_invalid_tag("<label>")
    end

    def generate_instance_tag(object = forgeos_people(:user), method_name = :email)
      InstanceTag.new(:test, method_name, FormBuilder.new(:test, object, self, {}, nil), object)
    end

    def invalid_record
      record = forgeos_people(:user)
      record.email = 'toto'
      record.valid?

      return record
    end

    def generate_invalid_tag(input)
      ActionView::Base.field_error_proc.call(input, generate_instance_tag(invalid_record))
    end
  end
end
