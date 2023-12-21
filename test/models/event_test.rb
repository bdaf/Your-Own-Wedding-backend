require "test_helper"

class EventTest < ActiveSupport::TestCase
  setup do
    @event = events(:one)
    @clientUser = users(:client)
    @supportUser = users(:support)
  end
  
  test "should not create event without name" do
    # given and when
    event = @supportUser.events.create(date: @event.date)
    # then
    assert_not event.valid?
    assert event.errors[:name].any?
  end

  test "should not create event without date" do
    # given and when
    event = @supportUser.events.create(name: @event.name)
    # then
    assert_not event.valid?
    assert event.errors[:date].any?
  end

  test "should not create event without user" do
    # given and when
    event = Event.create(date: @event.date)
    # then
    assert_not event.valid?
    assert event.errors[:user].any?
  end
end
