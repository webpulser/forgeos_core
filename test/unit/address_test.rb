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

  test "could change type" do
    class ::AddressInherit < Address
    end
    address = Address.create(
      :address => '1 main street',
      :address_2 => 'second floor',
      :zip_code => '42',
      :city => 'toto',
      :country => geo_zones(:countries_084)
    )
    address.kind = 'AddressInherit'
    assert address.save
    assert_equal 'AddressInherit', address.kind
    assert_instance_of AddressInherit, Address.find(address.id)
    assert_kind_of Address, AddressInherit.find(address.id)
  end
end
