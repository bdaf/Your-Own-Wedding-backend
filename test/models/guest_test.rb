require "test_helper"

class GuestTest < ActiveSupport::TestCase
  setup do
    @guest = guests(:one)
    @organizerUser = users(:organizer)
    
    @organizerUser.organizer = organizers(:one)
    @organizerUser.save!
  end

  test "should not create guest without organizer" do
    # given and when
    guest = Guest.create(name: @guest.name, surname: @guest.surname);
    # then
    assert_not guest.valid?
    assert guest.errors[:organizer].any?
  end

  test "should not create guest without name" do
    # given and when
    guest = @organizerUser.organizer.guests.create(surname: @guest.surname);
    # then
    assert_not guest.valid?
    assert guest.errors[:name].any?
  end

  test "should not create guest without surname" do
    # given and when
    guest = @organizerUser.organizer.guests.create(name: @guest.name);
    # then
    assert_not guest.valid?
    assert guest.errors[:surname].any?
  end

  test "should not create guest with name greater than 50" do
    # given and when
    guest = @organizerUser.organizer.guests.create(name: "qwertyuio qwertyuio qwertyuio qwertyuio qwertyuio 0", surname: @guest.surname);
    # then
    assert_not guest.valid?
    assert guest.errors[:name].any?
  end

  test "should not create guest with surname greater than 50" do
    # given and when
    guest = @organizerUser.organizer.guests.create(name: @guest.name, surname: "qwertyuio qwertyuio qwertyuio qwertyuio qwertyuio 0");
    # then
    assert_not guest.valid?
    assert guest.errors[:surname].any?
  end
  
end
