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

  # Check if notes are of past event, if so, marks them as overdue
  def check_and_mark_note_as_overdue
    if self.event.date < Time.now
      if !self.status_done?
        self.update!(status: "overdue")
      end
    end
  end
end
