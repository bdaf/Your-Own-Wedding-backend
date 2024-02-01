class Provider < ApplicationRecord
    has_many :offers, dependent: :destroy
    belongs_to :user

    validates :address, presence: true
    validates :phone_number, presence: true

    def addition_data
        contact_data
    end

    def contact_data
        return {
            address: self.address,
            phone_number: self.phone_number
        }
    end
end
