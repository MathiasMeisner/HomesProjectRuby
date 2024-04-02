#routes.rb

Rails.application.routes.draw do
  namespace :api do
    resources :homes do
      get 'filter_homes', on: :collection
    end
  end
end
