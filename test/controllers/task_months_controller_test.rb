require "test_helper"

class TaskMonthsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_month = task_months(:one)
    @providerUser = users(:provider)
    @organizerUser = users(:organizer)
    @organizerUser.organizer = organizers(:one)
    @organizerUser.save!
    @organizer_2_User = users(:organizer_2)
  end

  test "should not get my task_months when not logged in" do
    get my_task_months_url, as: :json
    assert_response 401
  end

  test "should not get my task_months when logged in as provider" do
    sign_in_as @providerUser# , const_password 
    get my_task_months_url, as: :json
    assert_response 403
  end

  test "should get my task_months" do
    sign_in_as @organizerUser# , const_password 
    get my_task_months_url, as: :json
    assert_response :success
  end

  test "should get my task_months with tasks" do
    sign_in_as @organizerUser# , const_password 
    get my_task_months_url, as: :json
    assert_response :success
    assert_match "tasks", @response.body
  end

  test "should not show task_month when not logged in" do
    get task_month_url(@task_month), as: :json
    assert_response 401
  end

  test "should not show task_month when logged in as provider" do
    sign_in_as @providerUser# , const_password 
    get task_month_url(@task_month), as: :json
    assert_response 403
  end

  test "should not show task_month when logged in as not owner" do
    sign_in_as @organizer_2_User# , const_password 
    get task_month_url(@task_month), as: :json
    assert_response 403
  end

  test "should show task_month when logged in as owner" do
    sign_in_as @organizerUser# , const_password 
    get task_month_url(@task_month), as: :json
    assert_response :success
  end

  test "should not destroy task_month when not logged in" do
    assert_difference("TaskMonth.count", 0) do
      delete task_month_url(@task_month), as: :json
    end

    assert_response 401
  end

  test "should not destroy task_month when logged in as provider" do
    sign_in_as @providerUser# , const_password 
    assert_difference("TaskMonth.count", 0) do
      delete task_month_url(@task_month), as: :json
    end

    assert_response 403
  end

  test "should not destroy task_month when logged in as not owner" do
    sign_in_as @organizer_2_User# , const_password 
    assert_difference("TaskMonth.count", 0) do
      delete task_month_url(@task_month), as: :json
    end

    assert_response 403
  end

  test "should destroy task_month" do
    sign_in_as @organizerUser# , const_password 
    assert_difference("TaskMonth.count", -1) do
      delete task_month_url(@task_month), as: :json
    end

    assert_response :no_content
  end

  test "should destroy task_month also with tasks" do
    sign_in_as @organizerUser# , const_password 
    assert @task_month.tasks.count == 1
    assert_difference("TaskMonth.count", -1) do
      assert_difference("Task.count", -1) do
        delete task_month_url(@task_month), as: :json
      end 
    end

    assert_response :no_content
  end
end
