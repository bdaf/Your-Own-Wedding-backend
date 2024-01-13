require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @clients_event = events(:clients_event)
    @supports_event = events(:supports_event)
    @supportUser = users(:support)
    @clientUser = users(:client)
  end

  test "should not get index if not logged in" do
    get events_url, as: :json
    assert_response 401
  end

  test "should not get index if logged in as a not admin" do
    sign_in_as @clientUser# , const_password 
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

  test "should get my_events if logged in as a not support" do
    sign_in_as @clientUser# , const_password 
    get my_events_url, as: :json
    assert_response :success
  end

  test "should get my_events if logged in as a support" do
    sign_in_as @supportUser# , const_password 
    get my_events_url, as: :json
    assert_response :success
  end

  test "should get my_events in descending order of date" do
    sign_in_as @supportUser# , const_password
    get my_events_url, as: :json
    assert_response :success
    returnedEvents = JSON.parse(@response.body, {:symbolize_names=>true})
    assert_equal returnedEvents.first[:id], events(:early_event).id
    assert_equal returnedEvents.last(2).first[:id], events(:late_event).id
    assert_equal returnedEvents.last[:id], events(:latest_event).id
  end

  test "should get my_events with body with notes" do
    sign_in_as @clientUser# , const_password 
    get my_events_url, as: :json
    assert_response :success

    assert_match "notes", @response.body
  end

  test "should not create event if not logged in" do
    assert_difference("Event.count", 0) do
      post events_url, params: { event: { date: @supports_event.date, name: @supports_event.name } }, as: :json
    end

    assert_response 401
  end

  test "should not create event if logged in as a not support" do
    sign_in_as @clientUser# , const_password 
    assert_difference("Event.count", 0) do
      post events_url, params: { event: { date: @clients_event.date, name: @clients_event.name } }, as: :json
    end

    assert_response 403
  end

  test "should create event if logged in as a support" do
    sign_in_as @supportUser# , const_password 
    assert_difference("Event.count") do
      post events_url, params: { event: { date: @supports_event.date, name: @supports_event.name } }, as: :json
    end

    assert_response :created
  end

  test "should not show event if not logged in" do
    get event_url(@supports_event), as: :json
    assert_response 401
  end

  test "should show event if logged in as a not support and it's his event " do
    sign_in_as @clientUser# , const_password 
    get event_url(events(:clients_event)), as: :json
    assert_response :success
  end

  test "should show event with body with notes" do
    sign_in_as @clientUser# , const_password 
    get event_url(events(:clients_event)), as: :json
    assert_response :success

    assert_match "notes", @response.body
  end

  test "should not show event if logged in as a not support and it's not his event " do
    sign_in_as @clientUser# , const_password 
    get event_url(events(:supports_event)), as: :json
    assert_response 403
  end

  test "should show event if logged in as a support and it's his event" do
    sign_in_as @supportUser# , const_password 
    get event_url(events(:supports_event)), as: :json
    assert_response :success
  end

  test "should not show event if logged in as a support but it's not his event" do
    sign_in_as @supportUser# , const_password 
    get event_url(events(:clients_event)), as: :json
    assert_response 403
  end

  test "should not update event when not logged in" do
    patch event_url(@supports_event), params: { event: { date: @supports_event.date, name: @supports_event.name } }, as: :json
    assert_response 401
  end

  test "should not update event when logged as a not support even if its his event" do
    sign_in_as @clientUser# , const_password 
    patch event_url(@clients_event), params: { event: { date: @clients_event.date, name: @clients_event.name } }, as: :json
    assert_response 403
  end

  test "should not update event when logged in as a support and its not his event" do
    sign_in_as @supportUser# , const_password 
    patch event_url(@clients_event), params: { event: { date: @supports_event.date, name: @supports_event.name } }, as: :json
    assert_response 403
  end

  test "should update event when logged in as a support and its his event" do
    sign_in_as @supportUser# , const_password 
    patch event_url(@supports_event), params: { event: { date: @supports_event.date, name: @supports_event.name } }, as: :json
    assert_response :success
  end

  test "should not destroy if not logged in" do
    assert_difference("Event.count", 0) do
      delete event_url(@supports_event), as: :json
    end

    assert_response 401
  end

  test "should not destroy event if logged in as a client if its his event" do
    sign_in_as @clientUser# , const_password 
    assert_difference("Event.count", 0) do
      delete event_url(@clients_event), as: :json
    end

    assert_response 403
  end

  test "should not destroy event if logged in as a support and its not his event" do
    sign_in_as @supportUser# , const_password 
    assert_difference("Event.count", 0) do
      delete event_url(@clients_event), as: :json
    end
    assert_response 403
  end

  test "should destroy event if logged in as a support and its his event" do
    sign_in_as @supportUser# , const_password 
    assert_difference("Event.count", -1) do
      delete event_url(@supports_event), as: :json
    end

    assert_response :success
    assert_match event_has_been_deleted, @response.body
  end

  test "should destroy notes with event" do
    sign_in_as @supportUser# , const_password 
    difference = @supports_event.notes.count
    assert difference > 0
    assert_difference("Note.count", -difference) do
      assert_difference("Event.count", -1) do
        delete event_url(@supports_event), as: :json
      end
    end
    assert_response :success
    assert_match event_has_been_deleted, @response.body
  end
end
