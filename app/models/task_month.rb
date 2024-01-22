class TaskMonth < ApplicationRecord
  belongs_to :organizer
  has_many :tasks, dependent: :destroy

  validates :month_number, presence: true, numericality: { only_integer: true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 12 }
  validates :year, presence: true, length: {is: 4}, numericality: { only_numeric: true, :greater_than_or_equal_to => Time.now.year }

  def next_month_params
    if self.month_number < 12
      return ({organizer_id: self.organizer_id, month_number: self.month_number+1, year: self.year})
    else
      return ({organizer_id: self.organizer_id, month_number: 1, year: self.year+1})
    end
  end
end
