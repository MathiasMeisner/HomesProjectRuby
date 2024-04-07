#routes.rb

Rails.application.routes.draw do
  root 'api/homes#index'
  namespace :api do
    resources :favorites, only: [:create, :index, :destroy]
    resources :homes do
      get 'filter_homes', on: :collection
    end
  end
  get '/favorites/:user_id', to: 'favorites#index', as: 'user_favorites'
  post '/favorites/add', to: 'favorites#create'
  delete '/favorites/:id', to: 'favorites#destroy', as: 'delete_favorite'

  get '/register', to: 'users#new', as: 'register'
  post '/register', to: 'users#create'

  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  get "/me/user", to: "users#show"
  get "/me/session", to: "sessions#show"

end
