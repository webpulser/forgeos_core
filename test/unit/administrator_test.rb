require 'test_helper'

class AdministratorTest < ActiveSupport::TestCase
  test "should be a person" do
    assert_kind_of Person, Administrator.new
  end

  test "could access path" do
    role = Role.create(
      :name => 'admin',
      :rights => [Right.create(
        :name => 'products_show',
        :controller_name => 'products',
        :action_name => 'show'
      )]
    )
    people(:administrator).update_attribute(:role_id, role)
    assert people(:administrator).access_path?("products", "show")
  end

  test "couldn't access path" do
    role = Role.create(
      :name => 'admin',
      :rights => []
    )
    people(:administrator).update_attribute(:role_id, role)
    assert !people(:administrator).access_path?("products", "show")
  end

end
