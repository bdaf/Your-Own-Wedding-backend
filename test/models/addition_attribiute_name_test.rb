require "test_helper"

class AdditionAttribiuteNameTest < ActiveSupport::TestCase
  setup do
    @organizer = organizers(:one)
    @attr_name = addition_attribiute_names(:one)
  end

  test "should create addition attribiute" do
    # given and when
    addition_attr_name = @organizer.addition_attribiute_names.build(name: @attr_name.name, default_value: @attr_name.default_value);
    # then
    assert addition_attr_name.valid?
  end

  test "should not create addition attribiute name without name" do
    # given and when
    addition_attr_name = @organizer.addition_attribiute_names.build(default_value: @attr_name.default_value);
    # then
    assert_not addition_attr_name.valid?
    assert addition_attr_name.errors[:name].any?
  end

  test "should not create addition attribiute name with name greater than 50" do
    # given and when
    addition_attr_name = @organizer.addition_attribiute_names.build(name: "123456789 123456789 123456789 123456789 123456789 0", default_value: @attr_name.default_value);
    # then
    assert_not addition_attr_name.valid?
    assert addition_attr_name.errors[:name].any?
  end

  test "should not create addition attribiute name with default value greater than 250" do
    # given and when
    addition_attr_name = @organizer.addition_attribiute_names.build(default_value: "123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 0");
    # then
    assert_not addition_attr_name.valid?
    assert addition_attr_name.errors[:default_value].any?
  end
end
