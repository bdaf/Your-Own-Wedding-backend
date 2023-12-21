class Event < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy

  validates :date, :name, :user, presence: true
  validates :date, dates_be_future_ones: true
  validates :name, length: { minimum: 2, maximum: 50 }
end
