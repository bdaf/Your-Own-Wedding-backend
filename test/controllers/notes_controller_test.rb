require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
    @note = notes(:one)
  end
  # Don't need for now
  # test "should get index" do
  #   debugger
  #   get event_notes_url @event, as: :json
  #   assert_response :success
  # end

  test "should create note" do
    assert_difference("Note.count") do
      post event_notes_url @event, @note, params: { note: { body: @note.body, name: @note.name } }, as: :json
    end

    assert_response :created
  end

  test "should show note" do
    get event_note_url(@event, @note), as: :json
    assert_response :success
  end

  test "should update note" do
    patch event_note_url(@event, @note), params: { note: { body: @note.body, name: @note.name } }, as: :json
    assert_response :success
  end

  test "should destroy note" do
    assert_difference("Note.count", -1) do
      delete event_note_url(@event, @note), as: :json
    end

    assert_response :no_content
  end
end
