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
    offer = @supportUser.offers.build(address: @offer.address, description: @offer.description, title: @offer.title)
    assert_not offer.images.attached?
    # when
    offer.images.attach(io: File.open(Rails.root.join('test','fixtures','files','matka-boza-bolesna.jpg')), filename: 'matka-boza-bolesna.jpg', content_type: 'image/jpeg')
    # then
    assert offer.images.attached?
    assert offer.save
    assert offer.valid?
    assert_equal(offer.images.attachments.count, 1)
  end

  test "should create offer with images" do
    # given
    offer = @supportUser.offers.build(address: @offer.address, description: @offer.description, title: @offer.title)
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
     assert_not offer.valid?
    assert offer.errors[:user].any?
  end

  test "should not create offer with title having greater length than 50" do
    # given
    offer = @supportUser.offers.create(address: @offer.address, description: @offer.description, title: "0123456789012345678901234567890123456789012345678901234567890")
    # when
    offer.save
    # then
    assert_not offer.valid?
    assert offer.errors[:title].any?
  end

  test "should not create offer with title having less length than 2" do
    # given
    offer = @supportUser.offers.create(address: @offer.address, description: @offer.description, title: "0")
    # when
    offer.save
    # then
    assert_not offer.valid?
    assert offer.errors[:title].any?
  end

  test "should create offer with default category 'other'" do
    # given
    offer = @supportUser.offers.create(address: @offer.address, description: @offer.description, title: @offer.title)
    # when
    offer.save
    # then
    assert offer.valid?
    assert offer.category_other?
  end

  test "should not create offer with prize less than 0" do
    # given
    offer = @supportUser.offers.create(address: @offer.address, description: @offer.description, title: @offer.title, prize: -1)
    # when
    offer.save
    # then
    assert_not offer.valid?
    assert offer.errors[:prize].any?
  end

  test "should not create offer with prize more than 50 000" do
    # given
    offer = @supportUser.offers.create(address: @offer.address, description: @offer.description, title: @offer.title, prize: 50001)
    # when
    offer.save
    # then
    assert_not offer.valid?
    assert offer.errors[:prize].any?
  end
end
