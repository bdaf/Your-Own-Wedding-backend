require "test_helper"

class EventTest < ActiveSupport::TestCase
  setup do
    @event = events(:one)
    @providerUser = users(:provider)
  end
  
  test "should not create event without name" do
    # given and when
    event = @providerUser.events.create(date: @event.date)
    # then
    assert_not event.valid?
    assert event.errors[:name].any?
  end

  test "should not create event without user" do
    # given and when
    event = Event.create(date: @event.date, name: @event.name)
    # then
    assert_not event.valid?
    assert event.errors[:user].any?
  end

  test "should not create event without date" do
    # given and when
    event = @providerUser.events.create(name: @event.name)
    # then
    assert_not event.valid?
    assert event.errors[:date].any?
  end

  test "should not create event with date of past" do
    # given and when
    event = @providerUser.events.create(name: @event.name, date: Time.now.yesterday)
    # then
    assert_not event.valid?
    assert event.errors[:date].any?
  end

  test "should create event with date of future" do
    # given and when
    event = @providerUser.events.create(name: @event.name, date: Time.now + 10.day)
    # then
    assert event.valid?
  end

  test "should not create event with date of present" do
    # given and when
    event = @providerUser.events.create(name: @event.name, date: Time.now)
    # then
    assert_not event.valid?
    assert event.errors[:date].any?
  end

  test "should not create event with name length grater than 50" do
    # given and when
    event = @providerUser.events.create(name: "012345678901234567890123456789012345678901234567891", date: @event.date)
    # then
    assert_not event.valid?
    assert event.errors[:name].any?
  end

  test "should not create event with name length less than 2" do
    # given and when
    event = @providerUser.events.create(name: "0", date: @event.date)
    # then
    assert_not event.valid?
    assert event.errors[:name].any?
  end
end
