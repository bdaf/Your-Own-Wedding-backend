require "test_helper"

class OrganizerTest < ActiveSupport::TestCase

  setup do
    @userOrganizer = users(:organizer)
    @organizer = organizers(:one)
  end

  test "should create organizer user" do
    organizer = Organizer.new(celebration_date: @organizer.celebration_date)
    user = User.new(email: const_email, password: const_password, password_confirmation: const_password, organizer: organizer)

    assert organizer.valid?
    assert user.valid?
  end

  test "should not create organizer without celebration date" do
    organizer = Organizer.create()
    assert organizer.errors[:celebration_date].any?
  end

  test "should not create organizer with past celebration date" do
    organizer = Organizer.create(celebration_date: Time.now - 1.day)
    assert organizer.errors[:celebration_date].any?
  end
end
