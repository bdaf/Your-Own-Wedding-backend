class Event < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy

  validates :date, :name, :user, presence: true
end
