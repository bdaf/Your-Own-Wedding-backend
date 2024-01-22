require "test_helper"

class AdditionAttribiuteNameControllerTest < ActionDispatch::IntegrationTest
  setup do
    @addition_attribiute_name = addition_attribiute_names(:one)
    @organizer = organizers(:one)
    @organizerUser = users(:organizer)
    @organizerUser.organizer = @organizer
    @organizerUser.save!
  end
  
  test "should get my addition attribiute names" do
    sign_in_as @organizerUser# , const_password 
    get my_names_url, as: :json
    assert_response :success
  end

  test "should create my addition attribiute name" do
    sign_in_as @organizerUser# , const_password 
    assert_difference("AdditionAttribiuteName.count") do
      post names_url, params: { addition_attribiute_name: { organizer: @organizer.id, name: @addition_attribiute_name.name } }, as: :json
    end

    assert_response :created
  end

  test "should delete my addition attribiute names" do
    sign_in_as @organizerUser# , const_password 
    assert_difference("AdditionAttribiuteName.count", -1) do
      delete name_url(@addition_attribiute_name), as: :json
    end

    assert_response :success
  end
end
