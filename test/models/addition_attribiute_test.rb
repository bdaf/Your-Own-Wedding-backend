require "test_helper"

class AdditionAttribiuteTest < ActiveSupport::TestCase
  setup do
    @attr = addition_attribiutes(:one)
    @guest = guests(:one)
  end

  test "should create addition attribiute with the same attribiute name and unique guest" do
    # given and when
    addition_attr = guests(:three).addition_attribiutes.build(addition_attribiute_name: addition_attribiute_names(:one), value: @attr.value);
    # then
    assert addition_attr.valid?
  end

  test "should create addition attribiute with the same guest and unique attribiute name" do
    # given and when
    addition_attr = @guest.addition_attribiutes.build(addition_attribiute_name: addition_attribiute_names(:three), value: @attr.value);
    # then
    assert addition_attr.valid?
  end
  
  test "should not create addition attribiute with the same guest and attribiute name" do
    # given and when
    addition_attr = @guest.addition_attribiutes.build(addition_attribiute_name: @attr.addition_attribiute_name, value: @attr.value);
    # then
    assert_not addition_attr.valid?
    assert addition_attr.errors[:addition_attribiute_name].any?
  end

  test "should not create addition attribiute without guest" do
    # given and when
    addition_attr = AdditionAttribiute.new();
    # then
    assert_not addition_attr.valid?
    assert addition_attr.errors[:guest].any?
  end

  test "should not create addition attribiute without addition attribiute name" do
    # given and when
    addition_attr = @guest.addition_attribiutes.build();
    # then
    assert_not addition_attr.valid?
    assert addition_attr.errors[:addition_attribiute_name].any?
  end

  test "should not create addition attribiute without value" do
    # given and when
    addition_attr = @guest.addition_attribiutes.build();
    # then
    assert_not addition_attr.valid?
    assert addition_attr.errors[:value].any?
  end

  test "should not create addition attribiute with value greater than 250" do
    # given and when
    addition_attr = @guest.addition_attribiutes.build(value: "123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 0");
    # then
    assert_not addition_attr.valid?
    assert addition_attr.errors[:value].any?
  end
end
