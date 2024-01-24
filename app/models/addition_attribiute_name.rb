class AdditionAttribiuteName < ApplicationRecord
  has_many :addition_attribiutes, dependent: :destroy
  belongs_to :organizer

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 50}
  validates :default_value, length: {maximum: 250}
end
