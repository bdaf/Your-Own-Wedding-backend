json.extract! event, :id, :user_id, :name, :date, :created_at, :updated_at, :notes
json.url event_url(event, format: :json)
