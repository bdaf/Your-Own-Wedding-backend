require "test_helper"

class GuestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @guest = guests(:one)
    @guest_two = guests(:two)
    @supportUser = users(:support)
    @clientUser = users(:client)
  end

  test "should not get index when not logged in" do
    get guests_url, as: :json
    assert_response 401
  end

  test "should not get index when logged in as support" do
    sign_in_as @supportUser# , const_password 
    get guests_url, as: :json
    assert_response 403
  end

  test "should not get index when logged in as admin" do
    sign_in_as @clientUser# , const_password 
    get guests_url, as: :json
    assert_response 403
  end

  test "should get my guests when not logged in" do
    get my_guests_url, as: :json
    assert_response 401
  end

  test "should not get my guests when logged in as support" do
    sign_in_as @supportUser# , const_password 
    get my_guests_url, as: :json
    assert_response 403
  end

  test "should get my guests when logged in as client" do
    sign_in_as @clientUser# , const_password 
    get my_guests_url, as: :json
    assert_response :success
  end

  test "should get my guests when with addition attribiutes" do
    sign_in_as @clientUser# , const_password 
    get my_guests_url, as: :json
    assert_response :success

    assert_match "addition_attribiutes", @response.body
  end

  test "should not create guest when not logged in" do
    assert_difference("Guest.count", 0) do
      post guests_url, params: { guest: { name: @guest.name, phone_number: @guest.phone_number, surname: @guest.surname } }, as: :json
    end

    assert_response 401
  end

  test "should not create guest when logged in as support" do
    sign_in_as @supportUser# , const_password 
    assert_difference("Guest.count", 0) do
      post guests_url, params: { guest: { name: @guest.name, phone_number: @guest.phone_number, surname: @guest.surname } }, as: :json
    end

    assert_response 403
  end

  test "should create guest when logged in as client" do
    sign_in_as @clientUser# , const_password 
    assert_difference("Guest.count") do
      post guests_url, params: { guest: { name: @guest.name, phone_number: @guest.phone_number, surname: @guest.surname } }, as: :json
    end
    assert_response :created
  end

  test "should not show guest when not logged in" do
    get guest_url(@guest), as: :json
    assert_response 401
  end

  test "should not show guest when logged in as support" do
    sign_in_as @supportUser# , const_password 
    get guest_url(@guest), as: :json
    assert_response 403
  end

  test "should show guest when logged in as client" do
    sign_in_as @clientUser# , const_password 
    get guest_url(@guest), as: :json
    assert_response :success
  end

  test "should not update guest when not logged in" do
    patch guest_url(@guest), params: { guest: { name: @guest.name, phone_number: @guest.phone_number, surname: @guest.surname } }, as: :json
    assert_response 401
  end

  test "should update guest when logged in as support" do
    sign_in_as @supportUser# , const_password 
    patch guest_url(@guest), params: { guest: { name: @guest.name, phone_number: @guest.phone_number, surname: @guest.surname } }, as: :json
    assert_response 403
  end

  test "should update guest when logged in as client" do
    sign_in_as @clientUser# , const_password 
    patch guest_url(@guest), params: { guest: { name: @guest.name, phone_number: @guest.phone_number, surname: @guest.surname } }, as: :json
    assert_response :success
  end

  test "should not destroy guest when not logged in" do
    assert_difference("Guest.count", 0) do
      delete guest_url(@guest), as: :json
    end

    assert_response 401
  end

  test "should not destroy guest when logged in as support" do
    sign_in_as @supportUser# , const_password 
    assert_difference("Guest.count", 0) do
      delete guest_url(@guest), as: :json
    end

    assert_response 403
  end

  test "should destroy guest when logged in as client" do
    sign_in_as @clientUser# , const_password 
    assert_difference("Guest.count", -1) do
      delete guest_url(@guest), as: :json
    end

    assert_response :no_content
  end

  test "should delete also attribiutes when guest is deleted" do
    sign_in_as @clientUser# , const_password 
    assert @guest.addition_attribiutes.count == 2
    assert_difference("Guest.count", -1) do
      assert_difference("AdditionAttribiute.count", -2) do
        delete guest_url(@guest), as: :json
      end
    end
    assert_response :no_content
  end
end
