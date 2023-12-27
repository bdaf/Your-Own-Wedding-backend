require "test_helper"

class GuestTest < ActiveSupport::TestCase
  setup do
    @guest = guests(:one)
    @clientUser = users(:client)
    @secondClientUser = users(:client_2)
    @supportUser = users(:support)
  end

  test "should not create guest without user" do
    # given and when
    guest = Guest.create(name: @guest.name, surname: @guest.surname, phone_number: @guest.phone_number);
    # then
    assert_not guest.valid?
    assert guest.errors[:user].any?
  end

  test "should not create guest without name" do
    # given and when
    guest = @clientUser.guests.create(surname: @guest.surname, phone_number: @guest.phone_number);
    # then
    assert_not guest.valid?
    assert guest.errors[:name].any?
  end

  test "should not create guest without surname" do
    # given and when
    guest = @clientUser.guests.create(name: @guest.name, phone_number: @guest.phone_number);
    # then
    assert_not guest.valid?
    assert guest.errors[:surname].any?
  end

  test "should not create guest without phone number" do
    # given and when
    guest = @clientUser.guests.create(name: @guest.name, surname: @guest.surname);
    # then
    assert_not guest.valid?
    assert guest.errors[:phone_number].any?
  end
  
  
end
