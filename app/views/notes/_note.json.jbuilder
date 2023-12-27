json.extract! note, :id, :name, :body, :created_at, :updated_at
json.url event_note_url(event, note, format: :json)
