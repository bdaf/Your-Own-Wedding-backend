require "test_helper"

class OffersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @offer = offers(:one)
    @clientUser = users(:client)
    @supportUser = users(:support)
  end

  test "should get index" do
    get offers_url, as: :json
    assert_response :success
  end

  test "should create offer being logged in as support" do
    sign_in_as @supportUser, "12341234"
    assert_difference("Offer.count") do
      post offers_url, params: {offer: { address: @offer.address, description: @offer.description, title: @offer.title} }, as: :json
    end

    assert_response :created
  end

  test "should not create offer being logged in as a not support" do
    sign_in_as @clientUser, "12341234"

    assert_difference("Offer.count", 0) do
      post offers_url, params: {offer: { address: @offer.address, description: @offer.description, title: @offer.title} }, as: :json
    end

    assert_response 403
  end

  test "shouldn not create offer being logged out" do
    assert_difference("Offer.count", 0) do
      post offers_url, params: {offer: { address: @offer.address, description: @offer.description, title: @offer.title} }, as: :json
    end

    assert_response 401
  end

  test "should show offer" do
    get offer_url(@offer), as: :json
    assert_response :success
  end

  test "should update offer" do
    patch offer_url(@offer), params: { offer: { address: @offer.address, description: @offer.description, title: @offer.title } }, as: :json
    assert_response :success
  end

  test "should destroy offer" do
    assert_difference("Offer.count", -1) do
      delete offer_url(@offer), as: :json
    end

    assert_response :no_content
  end
end
