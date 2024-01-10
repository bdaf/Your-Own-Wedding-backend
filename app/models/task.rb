class Task < ApplicationRecord
  belongs_to :task_month

  validates :name, presence: true, length: {maximum: 50}
  validates :description, presence: true, length: {maximum: 250}

  enum status: {
    undone: 0,
    done: 1,
    deleted: 2 
  }, _prefix: true
  validates :status, presence: true, inclusion: { in: %w(undone done deleted) }
end
