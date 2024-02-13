class User < ApplicationRecord
    has_many :events, dependent: :destroy
    has_secure_password
    has_one :organizer, dependent: :destroy
    has_one :provider, dependent: :destroy

    enum role: {
        organizer: 0,
        provider: 1
    }, _prefix: true
    validates :role, presence: true, inclusion: { in: %w(organizer provider) }

    validates :organizer, presence: true, if: :is_organizer
    validates :provider, presence: true, if: :is_provider

    def set_role_model role_model
        self.organizer = role_model if self.role_organizer?
        self.provider = role_model if self.role_provider?
    end

    def is_organizer
        self.role_organizer?
    end

    def is_provider
        self.role_provider?
    end

    def addition_data_based_on_role   
        self.send(self.role).addition_data
    end

    def hide_password   
        self.password_digest = "HIDDEN"
    end

    VALID_BASIC_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/
    validates :email, presence: true, format: { with: VALID_BASIC_EMAIL_REGEX}, uniqueness: { case_sensitive: false }, length: {maximum: 50}

    PASSWORD_FORMAT = /\A
        (?=.{8,})          # Must contain 8 or more characters
        (?=.*\d)           # Must contain a digit
        (?=.*[a-z])        # Must contain a lower case character
        (?=.*[A-Z])        # Must contain an upper case character
        (?=.*[[:^alnum:]]) # Must contain a symbol
    /x
    
    validates :password, 
    presence: true, 
    length: { in: 8..50 }, 
    format: { with: PASSWORD_FORMAT, message: "should have digit and lower and upper case and special character"}, 
    confirmation: true, 
    on: :create

    validates :password, 
    allow_nil: true, 
    length: { in: 8..50 }, 
    format: { with: PASSWORD_FORMAT }, 
    confirmation: true, 
    on: :update
end
