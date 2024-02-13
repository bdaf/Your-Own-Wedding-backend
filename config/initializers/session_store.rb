if Rails.env == "production"
    Rails.application.config.session_store :cookie_store, :key => '_authentication', :domain => "https://your-own-wedding.fly.dev", :same_site => :none, httponly: :false, secure: true
else
    Rails.application.config.session_store :cookie_store, :key => '_authentication'
end