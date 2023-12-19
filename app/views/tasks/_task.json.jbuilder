json.extract! task, :id, :task_month_id, :name, :description, :created_at, :updated_at
json.url task_url(task, format: :json)
