require "test_helper"

class AdditionAttribiuteTest < ActiveSupport::TestCase
  setup do
    @organizer = organizers(:one)
    @attr = addition_attribiutes(:one)
    @attr_name = addition_attribiute_names(:one)
    @guest = guests(:one)
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
