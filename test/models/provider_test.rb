require "test_helper"

class ProviderTest < ActiveSupport::TestCase
  setup do
    @userProvider = users(:provider)
    @provider = providers(:one)
  end

  test "should create provider user with provider data (phone_number and address)" do
    provider = Provider.new(phone_number: @provider.phone_number, address: @provider.address)
    user = User.new(email: "ShouldCreateUser@yow.pl", password: const_password, password_confirmation: const_password, role: @userProvider.role, provider: provider)
    assert provider.valid?
    assert user.valid?
  end

  test "should not create provider user without address" do
    provider = Provider.new
    user = User.create(email: "ShouldCreateUser@yow.pl", password: const_password, password_confirmation: const_password, role: @userProvider.role, provider: provider)
    assert user.valid?
    assert provider.errors[:address].any?
  end

  test "should not create provider user without phone number" do
    provider = Provider.new
    user = User.create(email: "ShouldCreateUser@yow.pl", password: const_password, password_confirmation: const_password, role: @userProvider.role, provider: provider)
    assert user.valid?
    assert provider.errors[:phone_number].any?
  end
end
