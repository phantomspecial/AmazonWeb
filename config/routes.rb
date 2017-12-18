Rails.application.routes.draw do

  root "stocks#index"

  resources :stocks
  resources :items
  resources :orders

end
