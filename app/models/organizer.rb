class Organizer < ApplicationRecord
    has_many :guests, dependent: :destroy
    has_many :task_months, dependent: :destroy
    has_many :addition_attribiute_names, dependent: :destroy
    belongs_to :user

    validates :celebration_date, presence: true, dates_be_future_ones: true

    def addition_data 
        {
            days_to_ceremony: self.days_to_ceremony
        }
    end
    
    def days_to_ceremony
        days = (self.celebration_date - Time.now).to_i / 3600 / 24
        days = 0 if days < 0
        return days
    end
end
