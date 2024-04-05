#routes.rb

Rails.application.routes.draw do
  root 'api/homes#index'
  namespace :api do
    resources :homes do
      get 'filter_homes', on: :collection
    end
  end

  get '/register', to: 'users#new', as: 'register'
  post '/register', to: 'users#create'

  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  get "/me/user", to: "users#show"
  get "/me/session", to: "sessions#show"

  get '/favorites', to: 'favorites#index', as: 'favorites'

end
