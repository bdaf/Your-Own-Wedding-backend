class Organizer < ApplicationRecord
    has_one :user, dependent: :destroy
    has_many :guests, dependent: :destroy
    has_many :task_months, dependent: :destroy

    validates :celebration_date, presence: true, dates_be_future_ones: true
end
