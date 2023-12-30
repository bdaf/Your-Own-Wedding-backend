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
    image_to_upload = fixture_file_upload(Rails.root.join('test','fixtures','files/matka-boza-bolesna.jpg'), 'image/jpeg')
    assert_difference("Offer.count") do
      post offers_url, params: {
        offer: { 
          address: @offer.address, description: @offer.description, title: @offer.title, images: [image_to_upload]
      } }
    end
    body_as_hash = JSON.parse(@response.body, {:symbolize_names=>true})
    assert newly_created_offer= Offer.find(body_as_hash[:id])
    assert_match "matka-boza-bolesna.jpg", url_for(newly_created_offer.images.first)
    assert_nil newly_created_offer.images.second
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
      } }
    end
    body_as_hash = JSON.parse(@response.body, {:symbolize_names=>true})
    assert newly_created_offer= Offer.find(body_as_hash[:id])
    assert_match "matka-boza-bolesna.jpg", url_for(newly_created_offer.images.first)
    assert_match "matka-boza-bolesna.jpg", url_for(newly_created_offer.images.second)
    assert_match "matka-boza-bolesna.jpg", url_for(newly_created_offer.images.third)
    assert_nil newly_created_offer.images.fourth
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

  test "should not create offer being logged out" do
    assert_difference("Offer.count", 0) do
      post offers_url, params: {offer: { address: @offer.address, description: @offer.description, title: @offer.title} }, as: :json
    end

    assert_response 401
  end

  test "should show offer" do
    get offer_url(@offer), as: :json
    assert_response :success
  end

  test "should show offer with several images" do
    # given
    assert_equal 0, @offer.images.attachments.count

    @offer.images.attach(io: File.open(Rails.root.join('test','fixtures','files','matka-boza-bolesna.jpg')), filename: 'matka-boza-bolesna.jpg', content_type: 'image/jpeg')
    @offer.save!
    offer_with_image = Offer.find(@offer.id)

    assert_equal 1, offer_with_image.images.attachments.count
    assert_nil offer_with_image.images.second
    assert_match "matka-boza-bolesna.jpg", url_for(offer_with_image.images.first)
    # when
    get offer_url(offer_with_image)
    # then
    body_as_hash = JSON.parse(@response.body, {:symbolize_names=>true})
    assert (newly_created_offer = Offer.find(body_as_hash[:id]))
    assert_equal 1, offer_with_image.images.attachments.count
    assert_match "matka-boza-bolesna.jpg", url_for(newly_created_offer.images.first)

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

  test "should update offer with several images being logged in as support" do
    # given
    sign_in_as @supportUser# , const_password 
    assert_equal 0, @offer.images.attachments.count

    @offer.images.attach(io: File.open(Rails.root.join('test','fixtures','files','matka-boza-bolesna.jpg')), filename: 'matka-boza-bolesna.jpg', content_type: 'image/jpeg')
    @offer.save!
    offer_with_image = Offer.find(@offer.id)

    assert_equal 1, offer_with_image.images.attachments.count
    assert_nil offer_with_image.images.second
    assert_match "matka-boza-bolesna.jpg", url_for(offer_with_image.images.first)
    # when
    image = file_fixture_upload("pielgrzymka.png", "image/png")
    images = [image, image]
    patch offer_url(offer_with_image), params: { offer: { images: images } }
    # then
    body_as_hash = JSON.parse(@response.body, {:symbolize_names=>true})
    assert (newly_created_offer = Offer.find(body_as_hash[:id]))
    assert_match "pielgrzymka.png", url_for(newly_created_offer.images.first)
    assert_match "pielgrzymka.png", url_for(newly_created_offer.images.second)
    assert_equal 2, offer_with_image.images.attachments.count
    assert_nil newly_created_offer.images.third

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

  test "should destroy offer with several images included" do
    # given
    sign_in_as @supportUser# , const_password 
    assert_equal 0, @offer.images.attachments.count

    @offer.images.attach(io: File.open(Rails.root.join('test','fixtures','files','matka-boza-bolesna.jpg')), filename: 'matka-boza-bolesna.jpg', content_type: 'image/jpeg')
    @offer.images.attach(io: File.open(Rails.root.join('test','fixtures','files','pielgrzymka.png')), filename: 'pielgrzymka.png', content_type: 'image/png')
    @offer.save!
    offer_with_image = Offer.find(@offer.id)

    assert_equal 2, offer_with_image.images.attachments.count
    assert_match "matka-boza-bolesna.jpg", url_for(offer_with_image.images.first)
    assert_match "pielgrzymka.png", url_for(offer_with_image.images.second)
    # when
    assert_difference("ActiveStorage::Attachment.count", -2) do
      assert_difference("Offer.count", -1) do
        delete offer_url(@offer), as: :json
      end
    end
    # then
    assert_response :no_content
  end
end
