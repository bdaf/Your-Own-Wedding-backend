require "test_helper"

class GuestTest < ActiveSupport::TestCase
  setup do
    @guest = guests(:one)
    @clientUser = users(:client)
    @secondClientUser = users(:client_2)
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

  test "should create guest without phone number" do
    # given and when
    guest = @clientUser.guests.create(name: @guest.name, surname: @guest.surname);
    # then
    assert guest.valid?
  end
  
  test "should not create guest with phone number greater than 12" do
    # given and when
    guest = @clientUser.guests.create(name: @guest.name, surname: @guest.surname, phone_number: "+12123456789000");
    # then
    assert_not guest.valid?
    assert guest.errors[:phone_number].any?
  end

  test "should not create guest with name greater than 50" do
    # given and when
    guest = @clientUser.guests.create(name: "qwertyuio qwertyuio qwertyuio qwertyuio qwertyuio 0", surname: @guest.surname, phone_number: @guest.phone_number);
    # then
    assert_not guest.valid?
    assert guest.errors[:name].any?
  end

  test "should not create guest with surname greater than 50" do
    # given and when
    guest = @clientUser.guests.create(name: @guest.name, surname: "qwertyuio qwertyuio qwertyuio qwertyuio qwertyuio 0", phone_number: @guest.phone_number);
    # then
    assert_not guest.valid?
    assert guest.errors[:surname].any?
  end
  
end
