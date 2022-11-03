Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'users#index'

  resources :users, only: [:index, :create, :show, :update, :destroy]
  resources :recipes, only: [:index, :create, :show, :update, :destroy]

  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/user", to: "users#show"


end
