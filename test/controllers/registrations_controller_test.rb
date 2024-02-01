require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider = providers(:one)
    @providerUser = users(:provider)
    @providerUser.provider = @provider
    @providerUser.save!
  
    @organizer = organizers(:one)
    @organizerUser = users(:organizer)
    @organizerUser.organizer = @organizer
    @organizerUser.save!
  end

  # Below are tests related to organizer users

  test "should log in with proper credentials" do
    sign_in_as @organizerUser# , const_password
    get logged_in_url
  
    assert_equal true, @response.parsed_body[:logged_in]
  end

  test "should get amount of days left to celebration from organizer user" do
    sign_in_as @organizerUser# , const_password 
    get user_with_data_url
  
    assert_equal 365, @response.parsed_body[:addition_data][:days_to_ceremony]
  end

  test "should get contact data from provider user" do
    sign_in_as @providerUser# , const_password 
    get user_with_data_url
    
    assert_equal "Bialystok", @response.parsed_body[:addition_data][:address]
    assert_equal "999 999 999", @response.parsed_body[:addition_data][:phone_number]
  end

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

  test "should change profil settings for provider user" do
    sign_in_as @providerUser# , const_password 
    provider = {id: @provider.id, phone_number: @provider.phone_number + "123", address: @provider.address + "edited"}
    put profile_url, params: {user: {name: @providerUser.name + "edited", surname: @providerUser.surname + "edited", provider: provider} }, as: :json
      
    assert user_id = @response.parsed_body[:user][:id]
    newly_updated_user = User.find(user_id)
    assert newly_updated_user.role_provider?
    assert_equal @provider.phone_number + "123", newly_updated_user.provider.phone_number
    assert_equal @provider.address + "edited", newly_updated_user.provider.address
    assert_equal @providerUser.name + "edited", newly_updated_user.name
    assert_equal @providerUser.surname + "edited", newly_updated_user.surname
    assert_response :success
  end

  test "should change profil settings for organizer user" do
    sign_in_as @organizerUser# , const_password 
    organizer = {id: @organizer.id, celebration_date: @organizer.celebration_date + 3.days}
    put profile_url, params: {user: {name: @organizerUser.name + "edited", surname: @organizerUser.surname + "edited", organizer: organizer} }, as: :json
    assert user_id = @response.parsed_body[:user][:id]
    newly_updated_user = User.find(user_id)
    assert newly_updated_user.role_organizer?
    assert_equal @organizer.celebration_date + 3.days, newly_updated_user.organizer.celebration_date
    assert_equal @organizerUser.name + "edited", newly_updated_user.name
    assert_equal @organizerUser.surname + "edited", newly_updated_user.surname
    assert_response :success
  end

  test "should not change profil settings if not logged in" do
    organizer = {id: @organizer.id, celebration_date: @organizer.celebration_date + 3.days}
    put profile_url, params: {user: {name: @organizerUser.name + "edited", surname: @organizerUser.surname + "edited", organizer: organizer} }, as: :json
   
    assert_response 401
  end
end