class Offer < ApplicationRecord
    belongs_to :user
    has_many_attached :images

    validates :title, :description, :address, :user, presence: true
    validates :title, length: { minimum: 2, maximum: 50 }
    validates :prize, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 50000 }
    validates :category, length: { minimum: 2, maximum: 50 }
    
    validates :images, content_type: ['image/png', 'image/jpeg'], limit: { min: 0, max: 10, message: "total number can't be greater than 10" }

    enum category: {
        other: 0,
        music: 1,
        camera: 2,
        venue: 3 
    }, _prefix: true
    validates :category, inclusion: { in: %w(other music camera venue) }
    # attachable.variant :thumb, resize_to_limit: [100, 100]
end
