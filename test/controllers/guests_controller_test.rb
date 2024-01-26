require "test_helper"

class GuestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @guest = guests(:one)
    @providerUser = users(:provider)
    @addition_attribiute = addition_attribiutes(:one)

    @organizerUser = users(:organizer)
    @organizerUser.organizer = organizers(:one)
    @organizerUser.save!
  end

  test "should not get index when not logged in" do
    get guests_url, as: :json
    assert_response 401
  end

  test "should not get index when logged in as provider" do
    sign_in_as @providerUser# , const_password 
    get guests_url, as: :json
    assert_response 403
  end

  test "should not get index when logged in as admin" do
    sign_in_as @organizerUser# , const_password 
    get guests_url, as: :json
    assert_response 403
  end

  test "should get my guests when not logged in" do
    get my_guests_url, as: :json
    assert_response 401
  end

  test "should not get my guests when logged in as provider" do
    sign_in_as @providerUser# , const_password 
    get my_guests_url, as: :json
    assert_response 403
  end

  test "should get my guests when logged in as organizer" do
    sign_in_as @organizerUser# , const_password 
    get my_guests_url, as: :json
    assert_response :success
  end

  test "should get my guests when with addition attribiutes" do
    sign_in_as @organizerUser# , const_password 
    get my_guests_url, as: :json
    assert_response :success

    assert_match "addition_attribiutes", @response.body
  end

  test "should not create guest when not logged in" do
    assert_difference("Guest.count", 0) do
      post guests_url, params: { guest: { name: @guest.name, surname: @guest.surname } }, as: :json
    end

    assert_response 401
  end

  test "should not create guest when logged in as provider" do
    sign_in_as @providerUser# , const_password 
    assert_difference("Guest.count", 0) do
      post guests_url, params: { guest: { name: @guest.name, surname: @guest.surname } }, as: :json
    end

    assert_response 403
  end

  test "should create guest when logged in as organizer" do
    sign_in_as @organizerUser# , const_password 
    assert_difference("Guest.count") do
      post guests_url, params: { guest: { name: @guest.name, surname: @guest.surname } }, as: :json
    end
    assert_response :created
  end

  test "should create guest with addition attribiute logged in as organizer" do
    sign_in_as @organizerUser# , const_password 
    assert_difference("Guest.count") do
      assert_difference("AdditionAttribiute.count") do
        post guests_url, params: { guest: { name: @guest.name, surname: @guest.surname, addition_attribiutes:  [{value: @addition_attribiute.value, addition_attribiute_name_id: @addition_attribiute.addition_attribiute_name_id}] } }, as: :json
      end
    end
    assert_response :created
  end

  test "should not show guest when not logged in" do
    get guest_url(@guest), as: :json
    assert_response 401
  end

  test "should not show guest when logged in as provider" do
    sign_in_as @providerUser# , const_password 
    get guest_url(@guest), as: :json
    assert_response 403
  end

  test "should show guest when logged in as organizer" do
    sign_in_as @organizerUser# , const_password 
    get guest_url(@guest), as: :json
    assert_response :success
  end

  test "should not update guest when not logged in" do
    patch guest_url(@guest), params: { guest: { name: @guest.name, surname: @guest.surname } }, as: :json
    assert_response 401
  end

  test "should update guest when logged in as provider" do
    sign_in_as @providerUser# , const_password 
    patch guest_url(@guest), params: { guest: { name: @guest.name, surname: @guest.surname } }, as: :json
    assert_response 403
  end

  test "should update guest when logged in as organizer" do
    sign_in_as @organizerUser# , const_password 
    patch guest_url(@guest), params: { guest: { name: @guest.name, surname: @guest.surname } }, as: :json
    assert_response :success
  end

  test "should update guest with addition attribiute logged in as organizer" do
    value_before = @addition_attribiute.value
    sign_in_as @organizerUser# , const_password 
    patch guest_url(@guest), params: { guest: { name: @guest.name, surname: @guest.surname, addition_attribiutes:  [{addition_attribiute_name_id: @addition_attribiute.addition_attribiute_name_id, value: @addition_attribiute.value + "edited"}] } }, as: :json
    assert_response :success
    attr_from_response = @response.parsed_body[:addition_attribiutes].find { |a| a[:id] == @addition_attribiute.id }
    assert_equal value_before + "edited", attr_from_response[:value]
  end

  test "should update guest with addition attribiute adding in addition next attribiute - logged in as organizer" do
    value_before = @addition_attribiute.value
    sign_in_as @organizerUser# , const_password 
    assert_difference("AdditionAttribiute.count") do
      patch guest_url(@guest), params: { guest: { name: @guest.name, surname: @guest.surname, addition_attribiutes:  [
          {addition_attribiute_name_id: @addition_attribiute.addition_attribiute_name_id, value: @addition_attribiute.value + "edited"}, 
          {addition_attribiute_name_id: addition_attribiute_names(:three).id, value: @addition_attribiute.value}
        ] } }, as: :json
    end
    assert_response :success
    edted_attr_from_response = @response.parsed_body[:addition_attribiutes].find { |a| a[:id] == @addition_attribiute.id }
    assert_equal value_before + "edited", edted_attr_from_response[:value]
  end

  test "should update guest with addition attribiute not adding in addition next attribiute because it has name which doesn't have user - logged in as organizer" do
    value_before = @addition_attribiute.value
    addition_with_values_to_create = addition_attribiutes(:two)
    sign_in_as @organizerUser# , const_password 
    assert_difference("AdditionAttribiute.count", 0) do
      patch guest_url(@guest), params: { guest: { name: @guest.name, surname: @guest.surname, addition_attribiutes:  [
          {addition_attribiute_name_id: @addition_attribiute.addition_attribiute_name_id, value: @addition_attribiute.value + "edited"}, 
          {addition_attribiute_name_id: addition_with_values_to_create.addition_attribiute_name_id, value: addition_with_values_to_create.value}
        ] } }, as: :json
    end
    assert_response :success
    edted_attr_from_response = @response.parsed_body[:addition_attribiutes].find { |a| a[:id] == @addition_attribiute.id }
    assert_equal value_before + "edited", edted_attr_from_response[:value]
  end

  test "should not destroy guest when not logged in" do
    assert_difference("Guest.count", 0) do
      delete guest_url(@guest), as: :json
    end

    assert_response 401
  end

  test "should not destroy guest when logged in as provider" do
    sign_in_as @providerUser# , const_password 
    assert_difference("Guest.count", 0) do
      delete guest_url(@guest), as: :json
    end

    assert_response 403
  end

  test "should destroy guest when logged in as organizer" do
    sign_in_as @organizerUser# , const_password 
    assert_difference("Guest.count", -1) do
      delete guest_url(@guest), as: :json
    end

    assert_response :success
    assert_match guest_has_been_deleted, @response.body
  end

  test "should delete also attribiutes when guest is deleted" do
    sign_in_as @organizerUser# , const_password 
    assert @guest.addition_attribiutes.count == 2
    assert_difference("Guest.count", -1) do
      assert_difference("AdditionAttribiute.count", -2) do
        delete guest_url(@guest), as: :json
      end
    end
    assert_match guest_has_been_deleted, @response.body
  end
end
