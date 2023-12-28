require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:one)
    @task_month = task_months(:one)
    @supportUser = users(:support)
    @clientUser = users(:client)
    @client_2_User = users(:client_2)
  end
  # Don't need for now
  # test "should get index" do
  #   get task_month_tasks_url @task_month, as: :json
  #   assert_response :success
  # end

  test "should not create task when not logged in" do
    assert_difference("Task.count", 0) do
      post task_month_tasks_url(@task_month), params: { task: { description: @task.description, name: @task.name } }, as: :json
    end

    assert_response 401
  end

  test "should not create task when logged in as support" do
    sign_in_as @supportUser, "12341234"
    assert_difference("Task.count", 0) do
      post task_month_tasks_url(@task_month), params: { task: { description: @task.description, name: @task.name } }, as: :json
    end

    assert_response 403
  end

  test "should not create task when logged in as not owner" do
    sign_in_as @client_2_User, "12341234"
    assert_difference("Task.count", 0) do
      post task_month_tasks_url(@task_month), params: { task: { description: @task.description, name: @task.name } }, as: :json
    end

    assert_response 403
  end

  test "should create task" do
    sign_in_as @clientUser, "12341234"
    assert_difference("Task.count") do
      post task_month_tasks_url(@task_month), params: { task: { description: @task.description, name: @task.name } }, as: :json
    end

    assert_response :created
  end

  test "should not show task when not logged in" do
    get task_month_task_url(@task_month, @task), as: :json
    assert_response 401
  end

  test "should not show task when logged in as a support" do
    sign_in_as @supportUser, "12341234"
    get task_month_task_url(@task_month, @task), as: :json
    assert_response 403
  end

  test "should not show task when logged in as not owner" do
    sign_in_as @client_2_User, "12341234"
    get task_month_task_url(@task_month, @task), as: :json
    assert_response 403
  end

  test "should show task" do
    sign_in_as @clientUser, "12341234"
    get task_month_task_url(@task_month, @task), as: :json
    assert_response :success
  end

  test "should not update task when not logged in" do
    patch task_month_task_url(@task_month, @task), params: { task: { description: @task.description, name: @task.name } }, as: :json
    assert_response 401
  end

  test "should not update task when logged in as a support" do
    sign_in_as @supportUser, "12341234"
    patch task_month_task_url(@task_month, @task), params: { task: { description: @task.description, name: @task.name } }, as: :json
    assert_response 403
  end

  test "should not update task when logged in as not owner" do
    sign_in_as @client_2_User, "12341234"
    patch task_month_task_url(@task_month, @task), params: { task: { description: @task.description, name: @task.name } }, as: :json
    assert_response 403
  end

  test "should update task" do
    sign_in_as @clientUser, "12341234"
    patch task_month_task_url(@task_month, @task), params: { task: { description: @task.description, name: @task.name } }, as: :json
    assert_response :success
  end

  test "should not destroy task when not logged in" do
    assert_difference("Task.count", 0) do
      delete task_month_task_url(@task_month, @task), as: :json
    end

    assert_response 401
  end

  test "should destroy task when logged in as support" do
    sign_in_as @supportUser, "12341234"
    assert_difference("Task.count", 0) do
      delete task_month_task_url(@task_month, @task), as: :json
    end

    assert_response 403
  end

  test "should not destroy task when logged in as not owner of task_month" do
    sign_in_as @client_2_User, "12341234"
    assert_difference("Task.count", 0) do
      delete task_month_task_url(@task_month, @task), as: :json
    end

    assert_response 403
  end

  test "should destroy task" do
    sign_in_as @clientUser, "12341234"
    assert_difference("Task.count", -1) do
      delete task_month_task_url(@task_month, @task), as: :json
    end

    assert_response :no_content
  end
end
