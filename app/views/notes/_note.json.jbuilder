json.extract! note, :id, :event_id, :name, :body, :created_at, :updated_at
json.url note_url(note, format: :json)
