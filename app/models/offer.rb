class Offer < ApplicationRecord
    belongs_to :user
    has_many_attached :images

    validates :title, :description, :address, :user, presence: true
    validates :title, length: { minimum: 2, maximum: 50 }

    enum status: {
        created: 0,
        suspended: 1,
        deleted: 2 
    }, _prefix: true
    validates :status, presence: true, inclusion: { in: %w(created suspended deleted) }
    # attachable.variant :thumb, resize_to_limit: [100, 100]
end
