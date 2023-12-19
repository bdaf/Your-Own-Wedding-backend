class TaskMonth < ApplicationRecord
  belongs_to :user
  have_many :tasks, dependent: :destroy
end
