class Guest < ApplicationRecord
  belongs_to :user
  has_many :addition_attribiutes, dependent: :destroy

  validates :name, :surname, :phone_number, presence: true
  validates :name, :surname, length: {maximum: 50}
  validates :phone_number, length: {maximum: 12}
end
