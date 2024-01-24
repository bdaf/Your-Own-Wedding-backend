class Note < ApplicationRecord
  belongs_to :event

  validates :name, :body, :status, presence: true
  validates :name, length: { maximum: 50 }

  enum status: {
    undone: 0,
    done: 1,
    overdue: 2
}, _prefix: true
validates :status, presence: true, inclusion: { in: %w(undone done overdue) }
end
