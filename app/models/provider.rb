class Provider < ApplicationRecord
    has_one :user, dependent: :destroy
    has_many :offers, dependent: :destroy

    validates :city, presence: true
    validates :phone_number, presence: true
end
