json.extract! guest, :id, :user_id, :name, :surname, :phone_number, :created_at, :updated_at
json.url guest_url(guest, format: :json)
