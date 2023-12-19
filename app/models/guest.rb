class Guest < ApplicationRecord
  belongs_to :user
  has_many :addition_attribiutes, dependent: :destroy
end
