Rails.application.routes.draw do
  root to: 'cats#index'
  resources :cats
  
  resources :cat_rental_requests, only: [:new, :create, :destroy] do
    get 'approve'
    get 'deny'
  end
  
  resources :users, only: [:create, :new, :show]
  
  resource :session, only: [:create, :new, :destroy]
end