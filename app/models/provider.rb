class Provider < ApplicationRecord
    has_many :offers, dependent: :destroy
    belongs_to :user

    validates :address, presence: true
    validates :phone_number, presence: true
end
