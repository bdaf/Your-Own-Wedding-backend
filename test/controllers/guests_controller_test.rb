require "test_helper"

class GuestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @guest = guests(:one)
    @guest_two = guests(:two)
    @supportUser = users(:support)
    @clientUser = users(:client)
  end

  test "should get index" do
    get guests_url, as: :json
    assert_response :success
  end

  test "should create guest" do
    assert_difference("Guest.count") do
      post guests_url, params: { guest: { name: @guest.name, phone_number: @guest.phone_number, surname: @guest.surname, user_id: @guest.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show guest" do
    get guest_url(@guest), as: :json
    assert_response :success
  end

  test "should update guest" do
    patch guest_url(@guest), params: { guest: { name: @guest.name, phone_number: @guest.phone_number, surname: @guest.surname, user_id: @guest.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy guest" do
    assert_difference("Guest.count", -1) do
      delete guest_url(@guest), as: :json
    end

    assert_response :no_content
  end
end
