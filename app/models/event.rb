class Event < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy

  validates :date, :name, :user, presence: true
  validates :date, dates_be_future_ones: true
  validates :name, length: { minimum: 2, maximum: 50 }


  # Check if event is past, if so, marks its notes as overdue
  def check_and_mark_notes_as_overdue 
    if self.date < Time.now
      self.notes.each do |note|
        if !note.status_done?
          note.update!(status: "overdue")
        end
      end
    end
  end
end
