class AdditionAttribiuteName < ApplicationRecord
  has_many :addition_attribiutes, dependent: :destroy
  belongs_to :organizer

  validates :name, presence: true, length: {maximum: 50}, uniqueness: { scope: [:organizer, :name] }
  validates :default_value, length: {maximum: 250}
end
