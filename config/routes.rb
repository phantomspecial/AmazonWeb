Rails.application.routes.draw do

  devise_for :users
  root "stocks#index"

  resources :stocks
  resources :items do
    collection do
      get 'addto'
    end
  end
  resources :orders do
    collection do
      get 'delivery'
      get 'gift'
    end
  end
  resources :admin, only: [:index]
  resources :userpermissions, only: [:index, :update]
  resources :users, only: [:index, :show]
  resources :carts

end
