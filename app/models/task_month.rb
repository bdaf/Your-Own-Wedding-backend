class TaskMonth < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :month_number, presence: true, numericality: { only_integer: true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 12 }
  validates :year, presence: true, length: {is: 4}, numericality: { only_numeric: true, :greater_than_or_equal_to => Time.now.year }
end
