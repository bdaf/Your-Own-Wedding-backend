require "test_helper"

class TaskMonthsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_month = task_months(:one)
    @supportUser = users(:support)
    @clientUser = users(:client)
    @client_2_User = users(:client_2)
  end
  # Don't need for now
  # test "should get index" do
  #   get task_months_url, as: :json
  #   assert_response :success
  # end

  test "should not get my task_months when not logged in" do
    get my_task_months_url, as: :json
    assert_response 401
  end

  test "should not get my task_months when logged in as support" do
    sign_in_as @supportUser, "12341234"
    get my_task_months_url, as: :json
    assert_response 403
  end

  test "should get my task_months" do
    sign_in_as @clientUser, "12341234"
    get my_task_months_url, as: :json
    assert_response :success
  end

  test "should get my task_months with tasks" do
    sign_in_as @clientUser, "12341234"
    get my_task_months_url, as: :json
    assert_response :success
    assert_match "tasks", @response.body
  end

  test "should not show task_monthh when not logged in" do
    get task_month_url(@task_month), as: :json
    assert_response 401
  end

  test "should not show task_month when logged in as support" do
    sign_in_as @supportUser, "12341234"
    get task_month_url(@task_month), as: :json
    assert_response 403
  end

  test "should not show task_month when logged in as not owner" do
    sign_in_as @client_2_User, "12341234"
    get task_month_url(@task_month), as: :json
    assert_response 403
  end

  test "should show task_month when logged in as not owner" do
    sign_in_as @clientUser, "12341234"
    get task_month_url(@task_month), as: :json
    assert_response :success
  end

  test "should not destroy task_month when not logged in" do
    assert_difference("TaskMonth.count", 0) do
      delete task_month_url(@task_month), as: :json
    end

    assert_response 401
  end

  test "should not destroy task_month when logged in as support" do
    sign_in_as @supportUser, "12341234"
    assert_difference("TaskMonth.count", 0) do
      delete task_month_url(@task_month), as: :json
    end

    assert_response 403
  end

  test "should not destroy task_month when logged in as not owner" do
    sign_in_as @client_2_User, "12341234"
    assert_difference("TaskMonth.count", 0) do
      delete task_month_url(@task_month), as: :json
    end

    assert_response 403
  end

  test "should destroy task_month" do
    sign_in_as @clientUser, "12341234"
    assert_difference("TaskMonth.count", -1) do
      delete task_month_url(@task_month), as: :json
    end

    assert_response :no_content
  end

  test "should destroy task_month also with tasks" do
    sign_in_as @clientUser, "12341234"
    assert @task_month.tasks.count == 1
    assert_difference("TaskMonth.count", -1) do
      assert_difference("Task.count", -1) do
        delete task_month_url(@task_month), as: :json
      end 
    end

    assert_response :no_content
  end
end
