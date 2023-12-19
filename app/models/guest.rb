class Guest < ApplicationRecord
  belongs_to :user
  have_many :addition_attribiutes, dependent: :destroy
end
