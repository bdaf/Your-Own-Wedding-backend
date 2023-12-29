require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supportUser = users(:support)
    @clientUser = users(:client)
    @email = "ShouldCreateUser@yow.pl"
  end

  test "should register user and task_monts should be created as many as month left to ceremony - 12 because one year ahead" do
    assert_difference("User.count", 1) do
      post registrations_url, params: {user: { email: @email, password: const_password, password_confirmation: const_password, celebration_date: Time.now + 1.year} }, as: :json
    end
    body_as_hash = JSON.parse(@response.body, {:symbolize_names=>true})
    assert user_id = body_as_hash[:user][:id]
    newly_created_user = User.find(user_id)
    assert_equal 13, newly_created_user.task_months.count
    assert_response :success
  end
end