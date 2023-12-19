class User < ApplicationRecord
    has_secure_password
    have_many :offers, dependent: :destroy
    have_many :guests, dependent: :destroy
    have_many :task_months, dependent: :destroy
    have_many :events, dependent: :destroy
    
    enum role: {
        user: 0,
        support: 1,
        admin: 2 
    }

    validates_presence_of :email
    validates_uniqueness_of :email
    
    validates_presence_of :role
end
