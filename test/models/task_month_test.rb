require "test_helper"

class TaskMonthTest < ActiveSupport::TestCase
  setup do
    @clientUser = users(:client)
    @supportUser = users(:support)
    @task_month = task_months(:one)
    @task = tasks(:one)
    @note = notes(:one)
  end
  
  test "should not create task_month without user" do
    # given and when
    month = TaskMonth.create(month_number: @task_month.month_number, year: @task_month.year)
    # then
    assert_not month.valid?
    assert month.errors[:user].any?
  end

  test "should not create task_month without month_number" do
    # given and when
    month = @clientUser.task_months.build(year: @task_month.year)
    # then
    assert_not month.valid?
    assert month.errors[:month_number].any?
  end

  test "should not create task_month without year" do
    # given and when
    month = @clientUser.task_months.build(month_number: @task_month.month_number)
    # then
    assert_not month.valid?
    assert month.errors[:year].any?
  end

  test "should not create task_month with year greater than 4 characters" do
    # given and when
    month = @clientUser.task_months.build(month_number: @task_month.month_number, year: "20255")
    # then
    assert_not month.valid?
    assert month.errors[:year].any?
  end

  test "should not create task_month with year less than 4 characters" do
    # given and when
    month = @clientUser.task_months.build(month_number: @task_month.month_number, year: "202")
    # then
    assert_not month.valid?
    assert month.errors[:year].any?
  end

  test "should not create task_month with month_number less than 1" do
    # given and when
    month = @clientUser.task_months.build(month_number: 0, year: @task_month.year)
    # then
    assert_not month.valid?
    assert month.errors[:month_number].any?
  end

  test "should not create task_month with month_number greater than 12" do
    # given and when
    month = @clientUser.task_months.build(month_number: 13, year: @task_month.year)
    # then
    assert_not month.valid?
    assert month.errors[:month_number].any?
  end

  test "should not create task_month with year in past" do
    # given and when
    month = @clientUser.task_months.build(month_number: @task_month.month_number, year: Time.now.year - 1)
    # then
    assert_not month.valid?
    assert month.errors[:year].any?
  end

  test "should create task_month" do
    # given and when
    month = @clientUser.task_months.build(month_number: @task_month.month_number, year: @task_month.year)
    # then
    assert month.valid?
  end
end
