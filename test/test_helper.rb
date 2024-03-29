ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def const_password 
      return "Qwert123@" 
    end

    def const_email 
      return "ShouldCreateUser@yow.pl" 
    end

    def offer_has_been_deleted
      "Offer has been deleted"
    end

    def event_has_been_deleted
      "Event has been deleted"
    end

    def note_has_been_deleted
      "Note has been deleted"
    end

    def guest_has_been_deleted
      "Guest has been deleted"
    end

    def sign_in_as(user, password=const_password)
      post login_url, params: { user: {email: user.email, password: password } }
    end
  end
end
