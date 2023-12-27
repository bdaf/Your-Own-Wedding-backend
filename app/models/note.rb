class Note < ApplicationRecord
  belongs_to :event

  validates :name, :body, presence: true
  validates :name, length: { maximum: 50 }
end
