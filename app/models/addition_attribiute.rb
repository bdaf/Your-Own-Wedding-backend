class AdditionAttribiute < ApplicationRecord
  belongs_to :guest

  validates :name, presence: true, length: {maximum: 50}
  validates :value, presence: true, length: {maximum: 250}
end
