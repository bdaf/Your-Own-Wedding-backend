require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
    @supportUser = users(:support)
    @clientUser = users(:client)
  end

  test "should get index" do
    get events_url, as: :json
    assert_response :success
  end

  test "should create event" do
    assert_difference("Event.count") do
      post events_url, params: { event: { date: @event.date, name: @event.name, user_id: @event.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should not show event if not logged in" do
    get event_url(@event), as: :json
    assert_response 401
  end

  test "should not show event if logged in as a not support" do
    sign_in_as @clientUser, "12341234"
    get event_url(@event), as: :json
    assert_response 403
  end

  test "should show event if logged in as a support" do
    sign_in_as @supportUser, "12341234"
    get event_url(@event), as: :json
    assert_response :success
  end

  test "should not update when not logged in" do
    patch event_url(@event), params: { event: { date: @event.date, name: @event.name, user_id: @event.user_id } }, as: :json
    assert_response 401
  end

  test "should not update event when logged as a not support" do
    sign_in_as @clientUser, "12341234"
    patch event_url(@event), params: { event: { date: @event.date, name: @event.name, user_id: @event.user_id } }, as: :json
    assert_response 403
  end

  test "should update event when logged in as a support" do
    sign_in_as @supportUser, "12341234"
    patch event_url(@event), params: { event: { date: @event.date, name: @event.name, user_id: @event.user_id } }, as: :json
    assert_response :success
  end

  test "should not destroy if not logged in" do
    assert_difference("Event.count", 0) do
      delete event_url(@event), as: :json
    end

    assert_response 401
  end

  test "should not destroy event if logged in as a not support" do
    sign_in_as @clientUser, "12341234"
    assert_difference("Event.count", 0) do
      delete event_url(@event), as: :json
    end

    assert_response 403
  end

  test "should destroy event if logged in as a support" do
    sign_in_as @supportUser, "12341234"
    assert_difference("Event.count", -1) do
      delete event_url(@event), as: :json
    end

    assert_response :no_content
  end
end
