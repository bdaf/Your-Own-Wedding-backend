require "test_helper"

class TaskMonthsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_month = task_months(:one)
  end

  test "should get index" do
    get task_months_url, as: :json
    assert_response :success
  end

  test "should create task_month" do
    assert_difference("TaskMonth.count") do
      post task_months_url, params: { task_month: { month_number: @task_month.month_number, user_id: @task_month.user_id, year: @task_month.year } }, as: :json
    end

    assert_response :created
  end

  test "should show task_month" do
    get task_month_url(@task_month), as: :json
    assert_response :success
  end

  test "should update task_month" do
    patch task_month_url(@task_month), params: { task_month: { month_number: @task_month.month_number, user_id: @task_month.user_id, year: @task_month.year } }, as: :json
    assert_response :success
  end

  test "should destroy task_month" do
    assert_difference("TaskMonth.count", -1) do
      delete task_month_url(@task_month), as: :json
    end

    assert_response :no_content
  end
end
