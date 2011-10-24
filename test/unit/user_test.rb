require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should be a person" do
    assert_kind_of Person, User.new
  end

  test "could have user's age" do
    assert_equal 0, people(:user).age
  end

  test "could have UserCategories" do
    category = UserCategory.create(:name => 'users', :elements => [people(:user)])
    assert_equal [category], people(:user).categories
  end
end
