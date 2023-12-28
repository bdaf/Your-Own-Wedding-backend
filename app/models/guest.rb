class Guest < ApplicationRecord
  belongs_to :user
  has_many :addition_attribiutes, dependent: :destroy

  validates :name, :surname, :phone_number, presence: true
  validates :name, :surname, length: {maximum: 50}
  validates :phone_number, length: {maximum: 12}

  def uniq_names_of_all_addition_attribiutes
    addition_attribiutes_names = addition_attribiutes.map do |attr|
      attr.name
    end
    return addition_attribiutes_names.uniq
  end
end
