require "test_helper"

class OfferTest < ActiveSupport::TestCase

  setup do
    @offer = offers(:one)
    @clientUser = users(:client)
    @supportUser = users(:support)
  end
  
  test "should create offer with image" do
    # given
    offer = Offer.new(address: @offer.address, description: @offer.description, title: @offer.title, user_id: @supportUser.id)
    assert_not offer.images.attached?
    # when
    offer.images.attach(io: File.open('test/fixtures/files/matka-boza-bolesna.jpg'), filename: 'filename')
    # then
    assert offer.images.attached?
    assert offer.save!
    assert offer.id
    assert_equal(offer.images.attachments.count, 1)
  end

  test "should create offer with images" do
    # given
    offer = Offer.new(address: @offer.address, description: @offer.description, title: @offer.title, user_id: @supportUser.id)
    assert_not offer.images.attached?
    # when
    offer.images.attach(io: File.open('test/fixtures/files/matka-boza-bolesna.jpg'), filename: 'filename')
    offer.images.attach(io: File.open('test/fixtures/files/matka-boza-bolesna.jpg'), filename: 'filename')
    offer.images.attach(io: File.open('test/fixtures/files/matka-boza-bolesna.jpg'), filename: 'filename')
    # then
    assert offer.images.attached?
    assert offer.save!
    assert offer.id
    assert_equal(offer.images.attachments.count, 3)
  end

  test "should create offer without image" do
    # given
    # when
    offer = @supportUser.offers.create(address: @offer.address, description: @offer.description, title: @offer.title)
    # then
    assert offer
    assert offer.id
    assert_equal(offer.images.attachments.count, 0)
  end
end
