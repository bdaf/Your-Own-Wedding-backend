require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
    @note = notes(:one)
    @providers_note = notes(:providers_note)
    @providers_event = events(:providers_event)
    @providerUser = users(:provider)
    @organizerUser = users(:organizer)
  end

  test "should not create note if not logged" do
    assert_difference("Note.count", 0) do
      post event_notes_url(@providers_event), params: { note: { body: @note.body, name: @note.name } }, as: :json
    end

    assert_response 401
  end

  test "should not create note if not owner of event" do
    sign_in_as @organizerUser# , const_password 
    assert_difference("Note.count", 0) do
      post event_notes_url(@providers_event), params: { note: { body: @note.body, name: @note.name } }, as: :json
    end
    assert_response 403
  end

  test "should create note" do
    sign_in_as @providerUser# , const_password 
    assert_difference("Note.count") do
      post event_notes_url(@providers_event), params: { note: { body: @note.body, name: @note.name } }, as: :json
    end

    assert_response :created
  end

  test "should create note of not overdue event and note should have undone status" do
    event = events(:futurest_event)
    note = notes(:not_overdue_note)
    sign_in_as @providerUser# , const_password 

    assert_difference("Note.count") do
      post event_notes_url(event), params: { note: { body: note.body, name: note.name } }, as: :json
    end

    assert_response :created
    assert_equal "undone", @response.parsed_body[:status]
  end

  test "should create note of overdue event and note should have overdue status" do
    event = events(:overdue_event)
    note = notes(:overdue_note)
    sign_in_as @providerUser# , const_password 

    assert_difference("Note.count") do
      post event_notes_url(event), params: { note: { body: note.body, name: note.name } }, as: :json
    end

    assert_response :created
    assert_equal "overdue", @response.parsed_body[:status]
  end

  test "should not show note if not logged in" do
    get event_note_url(@providers_event, @providers_note), as: :json
    assert_response 401
  end

  test "should not show note if not owner of event" do
    sign_in_as @organizerUser# , const_password 
    get event_note_url(@providers_event, @providers_note), as: :json
    assert_response 403
  end

  test "should show note" do
    sign_in_as @providerUser# , const_password 
    get event_note_url(@providers_event, @providers_note), as: :json
    assert_response :success
  end

  test "should not update note if not logged in" do
    patch event_note_url(@providers_event, @providers_note), params: { note: { body: @note.body, name: @note.name } }, as: :json
    assert_response 401
  end

  test "should not update note if not owner of event" do
    sign_in_as @organizerUser# , const_password 
    patch event_note_url(@providers_event, @providers_note), params: { note: { body: @note.body, name: @note.name } }, as: :json
    assert_response 403
  end

  test "should update note" do
    sign_in_as @providerUser# , const_password 
    patch event_note_url(@providers_event, @providers_note), params: { note: { body: @note.body, name: @note.name } }, as: :json
    assert_response :success
  end

  test "should not destroy note if not logged in" do
    assert_difference("Note.count", 0) do
      delete event_note_url(@providers_event, @providers_note), as: :json
    end

    assert_response 401
  end

  test "should not destroy note if not owner of event" do
    sign_in_as @organizerUser# , const_password 
    assert_difference("Note.count", 0) do
      delete event_note_url(@providers_event, @providers_note), as: :json
    end

    assert_response 403
  end

  test "should destroy note" do
    sign_in_as @providerUser# , const_password 
    assert_difference("Note.count", -1) do
      delete event_note_url(@providers_event, @providers_note), as: :json
    end

    assert_response :success
    assert_match note_has_been_deleted, @response.body
  end
end
