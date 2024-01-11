require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supportUser = users(:support)
    @clientUser = users(:client)
    @adminUser = users(:admin)
    @email = "ShouldCreateUser@yow.pl"
  end

  test "should register support user and basic event should be created for flexible notes" do
    assert_difference("User.count", 1) do
      post register_url, params: {user: { email: @email, password: const_password, password_confirmation: const_password, role: @supportUser.role} }, as: :json
    end
    body_as_hash = JSON.parse(@response.body, {:symbolize_names=>true})
    assert user_id = body_as_hash[:user][:id]
    newly_created_user = User.find(user_id)
    assert newly_created_user.role_client?
    assert_equal 13, newly_created_user.task_months.count
    assert_response :success
  end

  test "should register client user and task_monts should be created as many as month left to ceremony - 13 because one year ahead inluding our month" do
    assert_difference("User.count", 1) do
      post register_url, params: {user: { email: @email, password: const_password, password_confirmation: const_password, celebration_date: Time.now + 1.year, role: @clientUser.role} }, as: :json
    end
    body_as_hash = JSON.parse(@response.body, {:symbolize_names=>true})
    assert user_id = body_as_hash[:user][:id]
    newly_created_user = User.find(user_id)
    assert newly_created_user.role_client?
    assert_equal 13, newly_created_user.task_months.count
    assert_response :success
  end

  test "should register support user" do
    assert_difference("User.count", 1) do
      post register_url, params: {user: { email: @email, password: const_password, password_confirmation: const_password, celebration_date: Time.now + 1.year, role: @supportUser.role} }, as: :json
    end
    body_as_hash = JSON.parse(@response.body, {:symbolize_names=>true})
    assert user_id = body_as_hash[:user][:id]
    newly_created_user = User.find(user_id)
    assert newly_created_user.role_support?
    assert_response :success
  end

  test "should not register admin even if in request this admin role is indicated" do
    assert_difference("User.count", 0) do
      post register_url, params: {user: { email: @email, password: const_password, password_confirmation: const_password, celebration_date: Time.now + 1.year, role: @adminUser.role} }, as: :json
    end
    assert_response :unprocessable_entity
  end
end