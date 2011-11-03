require 'test_helper'

class SerializedFieldHelperTest < ActionView::TestCase
  include Forgeos::SerializedFieldHelper

  test "should generate field name" do
    assert_equal "a][b][c][d", serialized_field_name('a', 'b', 'c', 'd')
    assert_equal "a][b][c][d", serialized_field_name(:a, :b, :c, :d)
    assert_equal "a][b][c][d", serialized_field_name(:a, :b, 'c', 'd')
  end

  test "should generate field" do
    object = { :toto => 1, :tata => '2'}
    form_builder = FormBuilder.new(:hash, object, self, {}, nil)
    assert_equal '<label for="hash_tata">titi</label><br /><input id="hash_tata" name="hash[tata]" size="30" type="text" value="2" />', serialized_field(form_builder, :text_field, :tata)
  end

  test "should generate field with activerecord" do
    object = people(:user)
    form_builder = FormBuilder.new(:user, object, self, {}, nil)
    assert_equal '<label for="user_lastname">name</label><br /><input id="user_lastname" name="user[lastname]" size="30" type="text" value="Doe" />', serialized_field(form_builder, :text_field, :lastname)
  end

  test "should generate field with check_box" do
    object = { :toto => '1', :tata => '2'}
    form_builder = FormBuilder.new(:hash, object, self, {}, nil)
    assert_equal '<label for="hash_toto">tutu</label><br /><input name="hash[toto]" type="hidden" value="0" /><input checked="checked" id="hash_toto" name="hash[toto]" type="checkbox" value="1" />', serialized_field(form_builder, :check_box, :toto)
  end

end
