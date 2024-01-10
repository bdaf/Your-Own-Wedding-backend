require "test_helper"

class NoteTest < ActiveSupport::TestCase
  setup do
    @event = events(:one)
    @event_two = events(:two)
    @note = notes(:one)
  end
  
  test "should create note through event with name and body" do
    # given and when
    note = @event.notes.create(name: @note.name, body: @note.body)
    # then
    assert note.valid?
  end

  test "should not create note without event" do
    # given and when
    note = Note.create(name: @note.name, body: @note.body)
    # then
    assert_not note.valid?
    assert note.errors[:event].any?
  end

  test "should not create note without name" do
    # given and when
    note = @event.notes.create(body: @note.body)
    # then
    assert_not note.valid?
    assert note.errors[:name].any?
  end

  test "should not create note without body" do
    # given and when
    note = @event.notes.create(name: @note.name)
    # then
    assert_not note.valid?
    assert note.errors[:body].any?
  end

  test "should not create note with name greater than 50 characters" do
    # given and when
    note = @event.notes.create(name: "012345678901234567890123456789012345678901234567890", body: @note.body)
    # then
    assert_not note.valid?
    assert note.errors[:name].any?
  end
end
