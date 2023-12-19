require "test_helper"

class AdditionAttribiutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @addition_attribiute = addition_attribiutes(:one)
  end

  test "should get index" do
    get addition_attribiutes_url, as: :json
    assert_response :success
  end

  test "should create addition_attribiute" do
    assert_difference("AdditionAttribiute.count") do
      post addition_attribiutes_url, params: { addition_attribiute: { guest_id: @addition_attribiute.guest_id, name: @addition_attribiute.name, value: @addition_attribiute.value } }, as: :json
    end

    assert_response :created
  end

  test "should show addition_attribiute" do
    get addition_attribiute_url(@addition_attribiute), as: :json
    assert_response :success
  end

  test "should update addition_attribiute" do
    patch addition_attribiute_url(@addition_attribiute), params: { addition_attribiute: { guest_id: @addition_attribiute.guest_id, name: @addition_attribiute.name, value: @addition_attribiute.value } }, as: :json
    assert_response :success
  end

  test "should destroy addition_attribiute" do
    assert_difference("AdditionAttribiute.count", -1) do
      delete addition_attribiute_url(@addition_attribiute), as: :json
    end

    assert_response :no_content
  end
end
