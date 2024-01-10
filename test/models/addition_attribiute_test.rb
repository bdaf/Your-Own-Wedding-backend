require "test_helper"

class AdditionAttribiuteTest < ActiveSupport::TestCase
  setup do
    @attr = addition_attribiutes(:one)
    @guest = guests(:one)
  end
  
  test "should not create addition attribiute without guest" do
    # given and when
    addition_attr = AdditionAttribiute.new(name: @attr.name, value: @attr.value);
    # then
    assert_not addition_attr.valid?
    assert addition_attr.errors[:guest].any?
  end

  test "should not create addition attribiute without name" do
    # given and when
    addition_attr = @guest.addition_attribiutes.build(value: @attr.value);
    # then
    assert_not addition_attr.valid?
    assert addition_attr.errors[:name].any?
  end

  test "should not create addition attribiute without value" do
    # given and when
    addition_attr = @guest.addition_attribiutes.build(name: @attr.name);
    # then
    assert_not addition_attr.valid?
    assert addition_attr.errors[:value].any?
  end

  test "should not create addition attribiute with name greater than 50" do
    # given and when
    addition_attr = @guest.addition_attribiutes.build(name: "123456789 123456789 123456789 123456789 123456789 0", value: @attr.value);
    # then
    assert_not addition_attr.valid?
    assert addition_attr.errors[:name].any?
  end

  test "should not create addition attribiute with value greater than 250" do
    # given and when
    addition_attr = @guest.addition_attribiutes.build(name: @attr.name, value: "123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 0");
    # then
    assert_not addition_attr.valid?
    assert addition_attr.errors[:value].any?
  end

  test "should return uniq values of name attribiutes" do
    # given
    assert @guest.addition_attribiutes.last.name == 'MyString'
    assert @guest.addition_attribiutes.first.name == 'MyString'
    # when
    names = @guest.uniq_names_of_all_addition_attribiutes
    # then
    assert_equal 1, names.length
    assert_equal 'MyString', names.first
  end
end
