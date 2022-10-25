Rails.application.routes.draw do
  resources :comments
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :users, only: [:index, :create, :show, :update, :destroy]
  resources :recipes, only: [:index, :create, :show, :update, :destroy]

  post :login, to: "sessions#login"

end
