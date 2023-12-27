class Guest < ApplicationRecord
  belongs_to :user
  has_many :addition_attribiutes, dependent: :destroy

  validates :name, :surname, :phone_number, presence: true
end
