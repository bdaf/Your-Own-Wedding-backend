class User < ApplicationRecord
    has_secure_password
    belongs_to :provider
    belongs_to :organizer
    has_many :events, dependent: :destroy
    
    enum role: {
        organizer: 0,
        provider: 1
    }, _prefix: true
    validates :role, presence: true, inclusion: { in: %w(organizer provider) }

    def is_organizer
        self.role_organizer?
    end
    def is_provider
        self.role_provider?
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
    format: { with: PASSWORD_FORMAT }, 
    confirmation: true, 
    on: :create

    validates :password, 
    allow_nil: true, 
    length: { in: 8..50 }, 
    format: { with: PASSWORD_FORMAT }, 
    confirmation: true, 
    on: :update
end
