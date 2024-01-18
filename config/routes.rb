Rails.application.routes.draw do
  
  get "events_my", to: "events#my", as: :my_events
  resources :events do 
    resources :notes
  end
  
  get "task_months_my", to: "task_months#my", as: :my_task_months
  resources :task_months do
    resources :tasks
  end

  get "guests_my", to: "guests#my", as: :my_guests
  resources :guests do
    get "names", to: "addition_attribiutes#names", as: :addition_attribiutes_names
    resources :addition_attribiutes
  end
  
  get "offers_my", to: "offers#my", as: :my_offers
  resources :offers
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post :register, to: "registrations#create"
  post :login, to: "sessions#create"
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
