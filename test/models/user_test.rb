require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @userClient = users(:client)
    @user_2_Client = users(:client_2)
    @userSupport = users(:support)
    @email = "ShouldCreateUser@yow.pl"
  end

  test "should have client as a default role" do
    user = User.create(email: @email, password: const_password, password_confirmation: const_password, celebration_date: @userClient.celebration_date)
    assert user.role_client?
  end

  test "should not create user without email" do
    user = User.create(password: const_password, password_confirmation: const_password, celebration_date: @userClient.celebration_date)
    assert_not user.valid?
    assert user.errors[:email].any?
  end

  test "should not create user with the same email" do
    user = User.create(email: @userClient.email, celebration_date: @userClient.celebration_date)
    assert_not user.valid?
    assert user.errors[:email].any?
  end

  test "should not create user with the email without at (@)" do
    user = User.create(email: "email_without_at", celebration_date: @userClient.celebration_date)
    assert_not user.valid?
    assert user.errors[:email].any?
  end

  test "should not create user with the email without domain after at" do
    user = User.create(email: "email_without_domain@", celebration_date: @userClient.celebration_date)
    assert_not user.valid?
    assert user.errors[:email].any?
  end

  test "should not create user without password" do
    user = User.create(email: @email, celebration_date: @userClient.celebration_date)
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should not create user without password with 8 minimum length" do
    user = User.create(email: @email, password: "Qwe123@", password_confirmation: "Qwe123@", celebration_date: @userClient.celebration_date)
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should not create user without password with lower case character" do
    user = User.create(email: @email, password: "QWE123@", password_confirmation: "QWE123@", celebration_date: @userClient.celebration_date)
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should not create user without password with upper case character" do
    user = User.create(email: @email, password: "qwe123@", password_confirmation: "qwe123@", celebration_date: @userClient.celebration_date)
    assert_not user.valid?
    assert user.errors[:password].any?
  end
  
  test "should not create user without password with digit" do
    user = User.create(email: @email, password: "QweQwe@", password_confirmation: "QweQwe@", celebration_date: @userClient.celebration_date)
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should not create user without password with symbol" do
    user = User.create(email: @email, password: "qwe1234", password_confirmation: "qwe1234", celebration_date: @userClient.celebration_date)
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should not create user without celebration date" do
    user = User.create(email: @email, password: const_password, password_confirmation: const_password)
    assert_not user.valid?
    assert user.errors[:celebration_date].any?
  end

  test "should not create user with past celebration date" do
    user = User.create(email: @email, password: const_password, password_confirmation: const_password, celebration_date: Time.now - 1.day)
    assert_not user.valid?
    assert user.errors[:celebration_date].any?
  end

  test "should create user" do
    user = User.create(email: "ShouldCreateUser@yow.pl", password: const_password, password_confirmation: const_password, celebration_date: @userClient.celebration_date)
    assert user.valid?
  end
end
