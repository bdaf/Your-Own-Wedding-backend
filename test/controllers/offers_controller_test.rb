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

  test "should create offer with image being logged in as support" do
    sign_in_as @supportUser# , const_password 
    assert_difference("Offer.count") do
      post offers_url, params: {
        offer: { 
          address: @offer.address, description: @offer.description, title: @offer.title, images: file_fixture_upload("matka-boza-bolesna.jpg", "image/png")
      } }, as: :json
    end
    debugger
    body_as_hash = JSON.parse(@response.body, {:symbolize_names=>true})
    assert offer_id = body_as_hash[:id]
    newly_created_offer= Offer.find(offer_id)
    debugger
    assert_match "matka-boza-bolesna.jpg", url_for(newly_created_offer.images.first)

    assert_response :created
  end

  test "should create offer with several images being logged in as support" do
    sign_in_as @supportUser# , const_password 
    image = file_fixture_upload("matka-boza-bolesna.jpg", "image/png")
    images = [image, image, image]
    assert_difference("Offer.count") do
      post offers_url, params: {
        offer: { 
          address: @offer.address, description: @offer.description, title: @offer.title, images: images
      } }, as: :json
    end

    assert_response :created
  end

  test "should create offer being logged in as support" do
    sign_in_as @supportUser# , const_password 
    assert_difference("Offer.count") do
      post offers_url, params: {offer: { address: @offer.address, description: @offer.description, title: @offer.title} }, as: :json
    end

    assert_response :created
  end

  test "should not create offer being logged in as a not support" do
    sign_in_as @clientUser# , const_password 

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

  test "should not update offer if not logged in " do
    patch offer_url(@offer), params: { offer: { address: @offer.address, description: @offer.description, title: @offer.title } }, as: :json
    assert_response 401
  end

  test "should not update offer if logged in as a not support" do
    sign_in_as @clientUser# , const_password 
    patch offer_url(@offer), params: { offer: { address: @offer.address, description: @offer.description, title: @offer.title } }, as: :json
    assert_response 403
  end

  test "should update offer if logged in as a support" do
    sign_in_as @supportUser# , const_password 
    patch offer_url(@offer), params: { offer: { address: @offer.address, description: @offer.description, title: @offer.title } }, as: :json
    assert_response :success
  end

  test "should not destroy offer if not logged in" do
    assert_difference("Offer.count", 0) do
      delete offer_url(@offer), as: :json
    end

    assert_response 401
  end

  test "should not destroy offer if logged in as not support" do
    sign_in_as @clientUser# , const_password 
    assert_difference("Offer.count", 0) do
      delete offer_url(@offer), as: :json
    end

    assert_response 403
  end

  test "should destroy offer if logged in as a support" do
    sign_in_as @supportUser# , const_password 
    assert_difference("Offer.count", -1) do
      delete offer_url(@offer), as: :json
    end

    assert_response :no_content
  end
end
