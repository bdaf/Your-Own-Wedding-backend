require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organizers_event = events(:organizers_event)
    @providers_event = events(:providers_event)
    @providerUser = users(:provider)
    @organizerUser = users(:organizer)
  end

  test "should not get index if not logged in" do
    get events_url, as: :json
    assert_response 401
  end

  test "should not get index if logged in as a not admin" do
    sign_in_as @organizerUser# , const_password 
    get events_url, as: :json
    assert_response 403
  end

  # Decided to not have admin role for now
  # test "should get index if logged in as a admin" do
  #   sign_in_as @adminUser# , const_password 
  #   get events_url, as: :json
  #   assert_response :success
  # end

  test "should not get my_events if not logged in" do
    get my_events_url, as: :json
    assert_response 401
  end

  test "should get my_events if logged in as a not provider" do
    sign_in_as @organizerUser# , const_password 
    get my_events_url, as: :json
    assert_response :success
  end

  test "should get my_events if logged in as a provider" do
    sign_in_as @providerUser# , const_password 
    get my_events_url, as: :json
    assert_response :success
  end

  test "should get my_events in descending order of date" do
    sign_in_as @providerUser# , const_password
    get my_events_url, as: :json
    assert_response :success
    returnedEvents = JSON.parse(@response.body, {:symbolize_names=>true})
    assert_equal returnedEvents.first[:id], events(:early_event).id
    assert_equal returnedEvents.last(2).first[:id], events(:late_event).id
    assert_equal returnedEvents.last[:id], events(:latest_event).id
  end

  test "should get my_events with body with notes" do
    sign_in_as @organizerUser# , const_password 
    get my_events_url, as: :json
    assert_response :success

    assert_match "notes", @response.body
  end

  test "should not create event if not logged in" do
    assert_difference("Event.count", 0) do
      post events_url, params: { event: { date: @providers_event.date, name: @providers_event.name } }, as: :json
    end

    assert_response 401
  end

  test "should not create event if logged in as a not provider" do
    sign_in_as @organizerUser# , const_password 
    assert_difference("Event.count", 0) do
      post events_url, params: { event: { date: @organizers_event.date, name: @organizers_event.name } }, as: :json
    end

    assert_response 403
  end

  test "should create event if logged in as a provider" do
    sign_in_as @providerUser# , const_password 
    assert_difference("Event.count") do
      post events_url, params: { event: { date: @providers_event.date, name: @providers_event.name } }, as: :json
    end

    assert_response :created
  end

  test "should not show event if not logged in" do
    get event_url(@providers_event), as: :json
    assert_response 401
  end

  test "should show event if logged in as a not provider and it's his event " do
    sign_in_as @organizerUser# , const_password 
    get event_url(events(:organizers_event)), as: :json
    assert_response :success
  end

  test "should show event with body with notes" do
    sign_in_as @organizerUser# , const_password 
    get event_url(events(:organizers_event)), as: :json
    assert_response :success

    assert_match "notes", @response.body
  end

  test "should not show event if logged in as a not provider and it's not his event " do
    sign_in_as @organizerUser# , const_password 
    get event_url(events(:providers_event)), as: :json
    assert_response 403
  end

  test "should show event if logged in as a provider and it's his event" do
    sign_in_as @providerUser# , const_password 
    get event_url(events(:providers_event)), as: :json
    assert_response :success
  end

  test "should not show event if logged in as a provider but it's not his event" do
    sign_in_as @providerUser# , const_password 
    get event_url(events(:organizers_event)), as: :json
    assert_response 403
  end

  test "should not update event when not logged in" do
    patch event_url(@providers_event), params: { event: { date: @providers_event.date, name: @providers_event.name } }, as: :json
    assert_response 401
  end

  test "should not update event when logged as a not provider even if its his event" do
    sign_in_as @organizerUser# , const_password 
    patch event_url(@organizers_event), params: { event: { date: @organizers_event.date, name: @organizers_event.name } }, as: :json
    assert_response 403
  end

  test "should not update event when logged in as a provider and its not his event" do
    sign_in_as @providerUser# , const_password 
    patch event_url(@organizers_event), params: { event: { date: @providers_event.date, name: @providers_event.name } }, as: :json
    assert_response 403
  end

  test "should update event when logged in as a provider and its his event" do
    sign_in_as @providerUser# , const_password 
    patch event_url(@providers_event), params: { event: { date: @providers_event.date, name: @providers_event.name } }, as: :json
    assert_response :success
  end

  test "should not destroy if not logged in" do
    assert_difference("Event.count", 0) do
      delete event_url(@providers_event), as: :json
    end

    assert_response 401
  end

  test "should destroy event if logged in as a organizer if its his event" do
    sign_in_as @organizerUser# , const_password 
    assert_difference("Event.count") do
      delete event_url(@organizers_event), as: :json
    end

    assert_match event_has_been_deleted, @response.body
  end

  test "should not destroy event if logged in as a provider and its not his event" do
    sign_in_as @providerUser# , const_password 
    assert_difference("Event.count", 0) do
      delete event_url(@organizers_event), as: :json
    end
    assert_response 403
  end

  test "should destroy event if logged in as a provider and its his event" do
    sign_in_as @providerUser# , const_password 
    assert_difference("Event.count", -1) do
      delete event_url(@providers_event), as: :json
    end

    assert_response :success
    assert_match event_has_been_deleted, @response.body
  end

  test "should destroy notes with event" do
    sign_in_as @providerUser# , const_password 
    difference = @providers_event.notes.count
    assert difference > 0
    assert_difference("Note.count", -difference) do
      assert_difference("Event.count", -1) do
        delete event_url(@providers_event), as: :json
      end
    end
    assert_response :success
    assert_match event_has_been_deleted, @response.body
  end
end
