require "test_helper"

class AdditionAttribiutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @guest = guests(:one)
    @addition_attribiute_name = addition_attribiute_names(:one)
    @addition_attribiute = addition_attribiutes(:one)
    @organizer_2_User = users(:organizer_2)
    @providerUser = users(:provider)
    @organizerUser = users(:organizer)
    @organizerUser.organizer = organizers(:one)
    @organizerUser.save!
  end

  # test "should not get names when not logged in" do
  #   get guest_addition_attribiutes_names_url @guest, as: :json
  #   assert_response 401
  # end

  # test "should not get names when logged in as provider" do
  #   sign_in_as @providerUser# , const_password 
  #   get guest_addition_attribiutes_names_url @guest, as: :json
  #   assert_response 403
  # end

  # test "should not get names when logged in as not owner" do
  #   sign_in_as @organizer_2_User# , const_password 
  #   get guest_addition_attribiutes_names_url @guest, as: :json
  #   assert_response 403
  # end

  test "should not create addition_attribiute if not logged in" do
    assert_difference("AdditionAttribiute.count", 0) do
      post guest_addition_attribiutes_url @guest, as: :json, params: {
         addition_attribiute: {
          guest: @guest.id, 
          addition_attribiute_name_id: @addition_attribiute_name.id, 
          value: @addition_attribiute.value 
        } 
      }
    end

    assert_response 401
  end

  test "should not create addition_attribiute if logged in as a provider" do
    sign_in_as @providerUser# , const_password 
    assert_difference("AdditionAttribiute.count", 0) do
      post guest_addition_attribiutes_url(@guest), as: :json, params: { addition_attribiute: {guest: @guest.id, addition_attribiute_name_id: @addition_attribiute_name.id, value: @addition_attribiute.value } }
    end

    assert_response 403
  end

  test "should not create addition_attribiute if logged in as not owner" do
    sign_in_as @organizer_2_User# , const_password 
    assert_difference("AdditionAttribiute.count", 0) do
      post guest_addition_attribiutes_url(@guest), as: :json, params: { addition_attribiute: {guest: @guest.id, addition_attribiute_name_id: @addition_attribiute_name.id, value: @addition_attribiute.value } }
    end

    assert_response 403
  end

  test "should create addition_attribiute" do
    sign_in_as @organizerUser# , const_password 
    assert_difference("AdditionAttribiute.count") do
      post guest_addition_attribiutes_url(@guest), as: :json, params: { addition_attribiute: {addition_attribiute_name_id: addition_attribiute_names(:three).id, value: @addition_attribiute.value } }
    end

    assert_response :created
  end

  test "should not show addition_attribiute when not logged in" do
    get guest_addition_attribiute_url(@guest.id, @addition_attribiute.id), as: :json
    assert_response 401
  end

  test "should show addition_attribiute when logged in as a provider" do
    sign_in_as @providerUser# , const_password 
    get guest_addition_attribiute_url(@guest.id, @addition_attribiute.id), as: :json
    assert_response 403
  end

  test "should show addition_attribiute when logged in as a not owner" do
    sign_in_as @organizer_2_User# , const_password 
    get guest_addition_attribiute_url(@guest.id, @addition_attribiute.id), as: :json
    assert_response 403
  end

  test "should show addition_attribiute" do
    sign_in_as @organizerUser# , const_password 
    get guest_addition_attribiute_url(@guest.id, @addition_attribiute.id), as: :json
    assert_response :success
  end
  
  test "should not destroy addition_attribiute when not logged in" do
    assert_difference("AdditionAttribiute.count", 0) do
      delete guest_addition_attribiute_url(@guest.id, @addition_attribiute.id), as: :json
    end
    
    assert_response 401
  end

  test "should not destroy addition_attribiute when logged in as provider" do
    sign_in_as @providerUser# , const_password 
    assert_difference("AdditionAttribiute.count", 0) do
      delete guest_addition_attribiute_url(@guest.id, @addition_attribiute.id), as: :json
    end
    
    assert_response 403
  end

  test "should not destroy addition_attribiute when logged in aas not owner" do
    sign_in_as @organizer_2_User# , const_password 
    assert_difference("AdditionAttribiute.count", 0) do
      delete guest_addition_attribiute_url(@guest.id, @addition_attribiute.id), as: :json
    end
    
    assert_response 403
  end

  test "should destroy addition_attribiute" do
    sign_in_as @organizerUser# , const_password 
    assert_difference("AdditionAttribiute.count", -1) do
      delete guest_addition_attribiute_url(@guest.id, @addition_attribiute.id), as: :json
    end
    
    assert_response :no_content
  end

  # # Don't need for now
  # test "should update addition_attribiute" do
  #   patch guest_addition_attribiute_url(@addition_attribiute), params: { addition_attribiute: { name: @addition_attribiute.name, value: @addition_attribiute.value } }, as: :json
  #   assert_response :success
  # end
end
