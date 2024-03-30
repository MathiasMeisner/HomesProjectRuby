#routes.rb

Rails.application.routes.draw do
  namespace :api do
    resources :homes, only: [:index]
  end
end