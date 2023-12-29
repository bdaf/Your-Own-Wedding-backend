class User < ApplicationRecord
    has_secure_password
    has_many :offers, dependent: :destroy
    has_many :guests, dependent: :destroy
    has_many :task_months, dependent: :destroy
    has_many :events, dependent: :destroy

    APPROVED_ROLES_DURING_REGISTRATION = ["support", "client"]
    

    validates :celebration_date, presence: true, dates_be_future_ones: true
    
    enum role: {
        client: 0,
        support: 1,
        admin: 2 
    }, _prefix: true
    validates :role, presence: true, inclusion: { in: %w(client support admin) }

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
