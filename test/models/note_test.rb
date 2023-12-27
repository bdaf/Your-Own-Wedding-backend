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

  test "should create note without body" do
    # given and when
    note = @event.notes.create(name: @note.name)
    # then
    assert_not note.valid?
    assert note.errors[:body].any?
  end
end
