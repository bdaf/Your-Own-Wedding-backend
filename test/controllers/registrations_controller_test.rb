require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @providerUser = users(:provider)
    @provider = providers(:one)
    @organizerUser = users(:organizer)
  end

  # Below are tests related to organizer users

  test "should register organizer user with basic event with example note" do
    assert_difference("User.count", 1) do
      post register_url, params: {user: { email: const_email, password: const_password, password_confirmation: const_password, celebration_date: Time.now + 1.year, role: @organizerUser.role} }, as: :json
    end
    body_as_hash = JSON.parse(@response.body, {:symbolize_names=>true})
    assert user_id = body_as_hash[:user][:id]
    newly_created_user = User.find(user_id)
    assert newly_created_user.role_organizer?
    assert_equal 1, newly_created_user.events.count
    assert_equal 1, newly_created_user.events.first.notes.count
    assert_response :success
  end

  test "should register organizer user and task_monts should be created as many as month left to ceremony - 13 because one year ahead inluding our month" do
    assert_difference("User.count", 1) do
      post register_url, params: {user: { email: const_email, password: const_password, password_confirmation: const_password, celebration_date: Time.now + 1.year, role: @organizerUser.role} }, as: :json
    end
    body_as_hash = JSON.parse(@response.body, {:symbolize_names=>true})
    assert user_id = body_as_hash[:user][:id]
    newly_created_user = User.find(user_id)
    assert newly_created_user.role_organizer?
    assert_equal 13, newly_created_user.organizer.task_months.count
    assert_response :success
  end

  # Below are tests related to provider users

  test "should register provider user" do
    assert_difference("User.count", 1) do
      post register_url, params: {user: { email: const_email, password: const_password, password_confirmation: const_password, role: @providerUser.role, phone_number: @provider.phone_number, address: @provider.address} }, as: :json
    end
    body_as_hash = JSON.parse(@response.body, {:symbolize_names=>true})
    assert user_id = body_as_hash[:user][:id]
    newly_created_user = User.find(user_id)
    assert newly_created_user.role_provider?
    assert_response :success
  end

  test "should register provider user with basic event with example note" do
    assert_difference("User.count", 1) do
      post register_url, params: {user: { email: const_email, password: const_password, password_confirmation: const_password, role: @providerUser.role, phone_number: @provider.phone_number, address: @provider.address} }, as: :json
      
    end
    body_as_hash = JSON.parse(@response.body, {:symbolize_names=>true})
    assert user_id = body_as_hash[:user][:id]
    newly_created_user = User.find(user_id)
    assert newly_created_user.role_provider?
    assert_equal 1, newly_created_user.events.count
    assert_equal 1, newly_created_user.events.first.notes.count
    assert_response :success
  end
end