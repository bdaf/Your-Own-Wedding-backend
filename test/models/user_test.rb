require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @userClient = users(:client)
    @user_2_Client = users(:client_2)
    @userSupport = users(:support)
  end

  test "should have client as a default role" do
    user = User.create()
    assert user.role_client?
  end

  test "should not create user without email" do
    user = User.create()
    assert_not user.valid?
    assert user.errors[:email].any?
  end

  test "should not create user with the same email" do
    user = User.create(email: @userClient.email)
    assert_not user.valid?
    assert user.errors[:email].any?
  end

  test "should not create user with the email without at (@)" do
    user = User.create(email: "email_without_at")
    assert_not user.valid?
    assert user.errors[:email].any?
  end

  test "should not create user with the email without domain after at" do
    user = User.create(email: "email_without_domain@")
    assert_not user.valid?
    assert user.errors[:email].any?
  end

  test "should not create user without password" do
    user = User.create(email: "ShouldCreateUser@yow.pl")
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should not create user without password with 8 minimum length" do
    user = User.create(email: "ShouldCreateUser@yow.pl", password: "Qwe123@")
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should not create user without password with lower case character" do
    user = User.create(email: "ShouldCreateUser@yow.pl", password: "QWE123@")
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should not create user without password with upper case character" do
    user = User.create(email: "ShouldCreateUser@yow.pl", password: "qwe123@")
    assert_not user.valid?
    assert user.errors[:password].any?
  end
  
  test "should not create user without password with digit" do
    user = User.create(email: "ShouldCreateUser@yow.pl", password: "QweQwe@")
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should not create user without password with symbol" do
    user = User.create(email: "ShouldCreateUser@yow.pl", password: "qwe1234")
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should create user" do
    user = User.create(email: "ShouldCreateUser@yow.pl", password: const_password, password_confirmation: const_password)
    assert user.valid?
  end
end
