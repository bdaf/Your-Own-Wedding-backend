class Guest < ApplicationRecord
  belongs_to :organizer
  has_many :addition_attribiutes, dependent: :destroy

  validates :name, :surname, presence: true
  validates :name, :surname, length: {maximum: 50}
end
