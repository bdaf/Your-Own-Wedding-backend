Rails.application.routes.draw do
  
  get "events_my", to: "events#my", as: :my_events
  resources :events do 
    resources :notes
  end
  
  resources :task_months do
    resources :tasks
  end

  resources :guests do
    resources :addition_attribiutes
  end
  
  resources :offers
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:create]
  resources :registrations, only: [:create]
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
