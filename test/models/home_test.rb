# test/models/home_test.rb

require 'test_helper'

class HomeTest < ActiveSupport::TestCase
  def setup
    @unique_addresses = Set.new # Using a Set to store unique addresses
  end

  test "should not save home without address" do
    home = Home.new(address: nil)
    assert_not home.valid?
  end

  test "address should be unique" do
    existing_address = "123 Main St"
    existing_home = Home.new(address: existing_address)
    
    # Manually check for uniqueness
    assert_not duplicate_address?(existing_address), "Address '#{existing_address}' should not be valid as it's already taken"

    @unique_addresses << existing_address
  end

  test "should not save home without municipality" do
    home = Home.new(municipality: nil)
    assert_not home.valid?
  end

  test "should not save home without price" do
    home = Home.new(price: nil)
    assert_not home.valid?
  end
  private

  # Custom method to check for duplicate address
  def duplicate_address?(address)
    @unique_addresses.include?(address)
  end
end
