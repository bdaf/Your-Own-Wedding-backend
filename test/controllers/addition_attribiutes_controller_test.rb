require "test_helper"

class AdditionAttribiutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @guest = guests(:one)
    @addition_attribiute = addition_attribiutes(:one)
    @client_2_User = users(:client_2)
    @supportUser = users(:support)
    @clientUser = users(:client)
  end

  # Don't need for now
  # test "should get index" do
  #   get guest_addition_attribiutes_url, as: :json
  #   assert_response :success
  # end

  test "should not get names when not logged in" do
    get guest_addition_attribiutes_names_url @guest, as: :json
    assert_response 401
  end

  test "should not get names when logged in as support" do
    sign_in_as @supportUser, "12341234"
    get guest_addition_attribiutes_names_url @guest, as: :json
    assert_response 403
  end

  test "should not get names when logged in as not owner" do
    sign_in_as @client_2_User, "12341234"
    get guest_addition_attribiutes_names_url @guest, as: :json
    assert_response 403
  end

  test "should get names" do
    sign_in_as @clientUser, "12341234"
    get guest_addition_attribiutes_names_url @guest, as: :json
    assert_response :success
    assert_match "names", @response.body
  end

  test "should not create addition_attribiute if not logged in" do
    assert_difference("AdditionAttribiute.count", 0) do
      post guest_addition_attribiutes_url @guest, params: { addition_attribiute: { name: @addition_attribiute.name, value: @addition_attribiute.value } }, as: :json
    end

    assert_response 401
  end

  test "should not create addition_attribiute if logged in as a support" do
    sign_in_as @supportUser, "12341234"
    assert_difference("AdditionAttribiute.count", 0) do
      post guest_addition_attribiutes_url(@guest), as: :json, params: { addition_attribiute: { name: @addition_attribiute.name, value: @addition_attribiute.value } }
    end

    assert_response 403
  end

  test "should not create addition_attribiute if logged in as not owner" do
    sign_in_as @client_2_User, "12341234"
    assert_difference("AdditionAttribiute.count", 0) do
      post guest_addition_attribiutes_url(@guest), as: :json, params: { addition_attribiute: { name: @addition_attribiute.name, value: @addition_attribiute.value } }
    end

    assert_response 403
  end

  test "should create addition_attribiute" do
    sign_in_as @clientUser, "12341234"
    assert_difference("AdditionAttribiute.count") do
      post guest_addition_attribiutes_url(@guest), as: :json, params: { addition_attribiute: { name: @addition_attribiute.name, value: @addition_attribiute.value } }
    end

    assert_response :created
  end

  test "should not show addition_attribiute when not logged in" do
    get guest_addition_attribiute_url(@guest, @addition_attribiute), as: :json
    assert_response 401
  end

  test "should show addition_attribiute when logged in as a support" do
    sign_in_as @supportUser, "12341234"
    get guest_addition_attribiute_url(@guest, @addition_attribiute), as: :json
    assert_response 403
  end

  test "should show addition_attribiute when logged in as a not owner" do
    sign_in_as @client_2_User, "12341234"
    get guest_addition_attribiute_url(@guest, @addition_attribiute), as: :json
    assert_response 403
  end

  test "should show addition_attribiute" do
    sign_in_as @clientUser, "12341234"
    get guest_addition_attribiute_url(@guest, @addition_attribiute), as: :json
    assert_response :success
  end
  
  test "should not destroy addition_attribiute when not logged in" do
    assert_difference("AdditionAttribiute.count", 0) do
      delete guest_addition_attribiute_url(@guest, @addition_attribiute), as: :json
    end
    
    assert_response 401
  end

  test "should not destroy addition_attribiute when logged in as support" do
    sign_in_as @supportUser, "12341234"
    assert_difference("AdditionAttribiute.count", 0) do
      delete guest_addition_attribiute_url(@guest, @addition_attribiute), as: :json
    end
    
    assert_response 403
  end

  test "should not destroy addition_attribiute when logged in aas not owner" do
    sign_in_as @client_2_User, "12341234"
    assert_difference("AdditionAttribiute.count", 0) do
      delete guest_addition_attribiute_url(@guest, @addition_attribiute), as: :json
    end
    
    assert_response 403
  end

  test "should destroy addition_attribiute" do
    sign_in_as @clientUser, "12341234"
    assert_difference("AdditionAttribiute.count", -1) do
      delete guest_addition_attribiute_url(@guest, @addition_attribiute), as: :json
    end
    
    assert_response :no_content
  end

  # # Don't need for now
  # test "should update addition_attribiute" do
  #   patch guest_addition_attribiute_url(@addition_attribiute), params: { addition_attribiute: { name: @addition_attribiute.name, value: @addition_attribiute.value } }, as: :json
  #   assert_response :success
  # end
end
