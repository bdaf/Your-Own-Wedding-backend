require "test_helper"

class OfferTest < ActiveSupport::TestCase

  setup do
    @offer = offers(:one)
    @clientUser = users(:client)
    @supportUser = users(:support)
  end
  
  test "should create offer without image" do
    # given and when
    offer = @supportUser.offers.create(address: @offer.address, description: @offer.description, title: @offer.title)
    # then
    assert offer
    assert offer.valid?
    assert_equal(offer.images.attachments.count, 0)
  end

  test "should create offer with image" do
    # given
    offer = Offer.new(address: @offer.address, description: @offer.description, title: @offer.title, user_id: @supportUser.id)
    assert_not offer.images.attached?
    # when
    offer.images.attach(io: File.open('test/fixtures/files/matka-boza-bolesna.jpg'), filename: 'filename')
    # then
    assert offer.images.attached?
    assert offer.save
    assert offer.valid?
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
    assert offer.save
    assert offer.valid?
    assert_equal(offer.images.attachments.count, 3)
  end

  test "should not create offer without title" do
    # given
    offer = @supportUser.offers.create(address: @offer.address, description: @offer.description)
    # when
    offer.save
    # then
    assert_not offer.valid?
    assert offer.errors[:title].any?
  end

  test "should not create offer without description" do
    # given
    offer = @supportUser.offers.create(address: @offer.address, title: @offer.title)
    # when
    offer.save
    # then
    assert_not offer.valid?
    assert offer.errors[:description].any?
  end

  test "should not create offer without address" do
    # given
    offer = @supportUser.offers.create(description: @offer.description, title: @offer.title)
    # when
    offer.save
    # then
    assert_not offer.valid?
    assert offer.errors[:address].any?
  end

  test "should not create offer without user" do
    # given
    offer = Offer.new(address: @offer.address, description: @offer.description, title: @offer.title)
    # when
    offer.save
    # then
    # assert offer.invalid?
    assert offer.errors[:user].any?
  end
end
