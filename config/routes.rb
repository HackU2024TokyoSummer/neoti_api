Rails.application.routes.draw do
  post "/login", to: 'sessions#create'
  get "/logout", to: "sessions#delete"

  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get '/wakes' => 'wakes#index', as: :wakes_index
  post '/wakes/create' => 'wakes#create', as: :wakes_create
  get '/pastwakes' => 'wakes#past'
  put '/neoti' => 'wakes#neoti'

  post '/customer' => 'customers#main'
  post '/card' => 'customers#card'
  post '/payment' => 'customers#payment'
  put '/register' => 'customers#register'
  # resources :wakes
  # Defines the root path route ("/")
  # root "posts#index"
end
