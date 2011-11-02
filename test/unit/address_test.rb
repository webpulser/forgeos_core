require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  test "should print" do
    address =  Address.new(
      :address => '1 main street',
      :address_2 => 'second floor',
      :zip_code => '42',
      :city => 'toto',
      :country => geo_zones(:countries_084)
    )
    assert_equal "1 main street second floor, 42 toto, MONACO", address.to_s
  end
end
