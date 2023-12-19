class User < ApplicationRecord
    has_secure_password
    has_many :offers, dependent: :destroy
    has_many :guests, dependent: :destroy
    has_many :task_months, dependent: :destroy
    has_many :events, dependent: :destroy
    
    enum role: {
        user: 0,
        support: 1,
        admin: 2 
    }

    validates_presence_of :email
    validates_uniqueness_of :email
    validates_presence_of :role
end
