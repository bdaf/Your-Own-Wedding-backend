class Event < ApplicationRecord
  belongs_to :user
  have_many :notes, dependent: :destroy
end
