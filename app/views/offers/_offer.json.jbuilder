json.extract! offer, :id, :title, :description, :address, :images, :created_at, :updated_at
json.url offer_url(offer, format: :json)
