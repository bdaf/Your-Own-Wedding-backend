class Guest < ApplicationRecord
  belongs_to :organizer
  has_many :addition_attribiutes, dependent: :destroy

  validates :name, :surname, presence: true
  validates :name, :surname, length: {maximum: 50}

  # def uniq_names_of_all_addition_attribiutes
  #   addition_attribiutes_names = addition_attribiutes.map do |attr|
  #     attr.name
  #   end
  #   return addition_attribiutes_names.uniq
  # end
end
