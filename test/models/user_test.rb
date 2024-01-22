require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @userOrganizer = users(:organizer)
  end

  test "should have organizer as a default role" do
    user = User.create(email: const_email, password: const_password, password_confirmation: const_password)
    assert user.role_organizer?
  end

  test "should not create user without email" do
    user = User.create(password: const_password, password_confirmation: const_password)
    assert_not user.valid?
    assert user.errors[:email].any?
  end

  test "should not create user with the same email" do
    user = User.create(email: @userOrganizer.email)
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
    user = User.create(email: const_email)
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should not create user without password with 8 minimum length" do
    user = User.create(email: const_email, password: "Qwe123@", password_confirmation: "Qwe123@")
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should not create user without password with lower case character" do
    user = User.create(email: const_email, password: "QWE123@", password_confirmation: "QWE123@")
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should not create user without password with upper case character" do
    user = User.create(email: const_email, password: "qwe123@", password_confirmation: "qwe123@")
    assert_not user.valid?
    assert user.errors[:password].any?
  end
  
  test "should not create user without password with digit" do
    user = User.create(email: const_email, password: "QweQwe@", password_confirmation: "QweQwe@")
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "should not create user without password with symbol" do
    user = User.create(email: const_email, password: "qwe1234", password_confirmation: "qwe1234")
    assert_not user.valid?
    assert user.errors[:password].any?
  end
end
