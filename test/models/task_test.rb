require "test_helper"

class TaskTest < ActiveSupport::TestCase
  setup do
    @task = tasks(:one)
    @task_month = task_months(:one)
  end

  test "should not create task without task_month" do
    # given and when
    task = Task.new(name: @task.name, description: @task.description)
    # then
    assert_not task.valid?
    assert task.errors[:task_month].any?
  end

  test "should not create task without name" do
    # given and when
    task = @task_month.tasks.build(description: @task.description)
    # then
    assert_not task.valid?
    assert task.errors[:name].any?
  end

  test "should not create task without description" do
    # given and when
    task = @task_month.tasks.build(name: @task.name)
    # then
    assert_not task.valid?
    assert task.errors[:description].any?
  end

  test "should not create task with nae consist of greater than 50 characters" do
    # given and when
    string_with_51_length = "123456789 123456789 123456789 123456789 123456789 0"
    task = @task_month.tasks.build(name: string_with_51_length, description: @task.description)
    # then
    assert_not task.valid?
    assert task.errors[:name].any?
  end

  test "should not create task with description consist of greater than 250 characters" do
    # given and when
    string_with_251_length = "123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 0"
    task = @task_month.tasks.build(name: @task.name, description: string_with_251_length)
    # then
    assert_not task.valid?
    assert task.errors[:description].any?
  end

  test "should create task" do
    # given and when
    task = @task_month.tasks.build(name: @task.name, description: @task.description)
    # then
    assert task.valid?
  end
end
