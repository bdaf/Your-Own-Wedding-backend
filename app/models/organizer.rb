class Organizer < ApplicationRecord
    has_many :guests, dependent: :destroy
    has_many :task_months, dependent: :destroy
    has_many :addition_attribiute_names, dependent: :destroy
    belongs_to :user

    validates :celebration_date, presence: true, dates_be_future_ones: true
end
