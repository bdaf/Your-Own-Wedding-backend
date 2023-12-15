Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
        origin "http://localhost:5173"
        resource "*", 
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true
    end

    allow do
        origin "http://kamil-your-own-wedding-react.herokuapp.com"
        resource "*", 
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true
    end
end