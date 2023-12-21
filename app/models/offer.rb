class Offer < ApplicationRecord
    belongs_to :user
    has_many_attached :images

    validates :title, :description, :address, :user, presence: true
    # attachable.variant :thumb, resize_to_limit: [100, 100]
end
