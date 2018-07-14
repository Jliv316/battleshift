Rails.application.routes.draw do
  root 'homepage#show'

  # Users resources
  resources :users, only: [:create, :update, :destroy, :index, :edit]
  get '/register', to: 'users#new'
  get '/dashboard/:id', to: 'users#show', as: :dashboard

  # Session resources
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  # Activation resources
  get '/activate/user', to: 'activation#show'

  # API resources
  namespace :api do
    namespace :v1 do
      post '/games', to: 'games#create'
      resources :games, only: [:show] do
        post '/ships', to: 'games#update'
        post '/shots', to: 'games/shots#create'
        # post "/shots", to: "games/shots#create"
      end
    end
  end

  # Game play resources
  post '/api/v1/games', to: 'games#create'
    
  # Notification resources
  post '/welcome', to: 'notification#create'
end
