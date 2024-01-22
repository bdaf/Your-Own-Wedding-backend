json.extract! task_month, :id, :organizer_id, :month_number, :year, :created_at, :updated_at, :tasks
json.url task_month_url(task_month, format: :json)
