json.extract! guest, :id, :organizer_id, :name, :surname, :addition_attribiutes, :created_at, :updated_at
json.url guest_url(guest, format: :json)
