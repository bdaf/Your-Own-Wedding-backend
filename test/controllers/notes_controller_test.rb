require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
    @note = notes(:one)
    @supports_note = notes(:supports_note)
    @clients_event = events(:clients_event)
    @supports_event = events(:supports_event)
    @supportUser = users(:support)
    @clientUser = users(:client)
  end

  # Don't need for now
  # test "should get index" do
  #   debugger
  #   get event_notes_url @event, as: :json
  #   assert_response :success
  # end

  test "should not create note if not logged" do
    assert_difference("Note.count", 0) do
      post event_notes_url(@supports_event), params: { note: { body: @note.body, name: @note.name } }, as: :json
    end

    assert_response 401
  end

  test "should not create note if not owner of event" do
    sign_in_as @clientUser# , const_password 
    assert_difference("Note.count", 0) do
      post event_notes_url(@supports_event), params: { note: { body: @note.body, name: @note.name } }, as: :json
    end
    assert_response 403
  end

  test "should create note" do
    sign_in_as @supportUser# , const_password 
    assert_difference("Note.count") do
      post event_notes_url(@supports_event), params: { note: { body: @note.body, name: @note.name } }, as: :json
    end

    assert_response :created
  end

  test "should not show note if not logged in" do
    get event_note_url(@supports_event, @supports_note), as: :json
    assert_response 401
  end

  test "should not show note if not owner of event" do
    sign_in_as @clientUser# , const_password 
    get event_note_url(@supports_event, @supports_note), as: :json
    assert_response 403
  end

  test "should show note" do
    sign_in_as @supportUser# , const_password 
    get event_note_url(@supports_event, @supports_note), as: :json
    assert_response :success
  end

  test "should not update note if not logged in" do
    patch event_note_url(@supports_event, @supports_note), params: { note: { body: @note.body, name: @note.name } }, as: :json
    assert_response 401
  end

  test "should not update note if not owner of event" do
    sign_in_as @clientUser# , const_password 
    patch event_note_url(@supports_event, @supports_note), params: { note: { body: @note.body, name: @note.name } }, as: :json
    assert_response 403
  end

  test "should update note" do
    sign_in_as @supportUser# , const_password 
    patch event_note_url(@supports_event, @supports_note), params: { note: { body: @note.body, name: @note.name } }, as: :json
    assert_response :success
  end

  test "should not destroy note if not logged in" do
    assert_difference("Note.count", 0) do
      delete event_note_url(@supports_event, @supports_note), as: :json
    end

    assert_response 401
  end

  test "should not destroy note if not owner of event" do
    sign_in_as @clientUser# , const_password 
    assert_difference("Note.count", 0) do
      delete event_note_url(@supports_event, @supports_note), as: :json
    end

    assert_response 403
  end

  test "should destroy note" do
    sign_in_as @supportUser# , const_password 
    assert_difference("Note.count", -1) do
      delete event_note_url(@supports_event, @supports_note), as: :json
    end

    assert_response :success
    assert_match note_has_been_deleted, @response.body
  end
end
