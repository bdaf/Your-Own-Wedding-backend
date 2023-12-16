class User < ApplicationRecord
    has_secure_password
    
    enum role: {
        user: 0,
        support: 1,
        admin: 2 
    }

    validates_presence_of :email
    validates_uniqueness_of :email
    
    validates_presence_of :role
end
