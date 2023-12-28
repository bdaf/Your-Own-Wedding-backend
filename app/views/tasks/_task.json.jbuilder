json.extract! task, :id, :task_month_id, :name, :description, :created_at, :updated_at
json.url task_month_task_url(task_month, task, format: :json)
