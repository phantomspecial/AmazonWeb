Rails.application.routes.draw do

  devise_for :users
  root "stocks#index"

  resources :stocks do
    collection do
      get 'search'
    end
  end
  resources :items do
    collection do
      get 'addto'
    end
  end
  resources :orders do
    collection do
      get 'confirm'
    end
  end
  resources :admin, only: [:index]
  resources :userpermissions, only: [:index, :update]
  resources :users, only: [:index, :show, :new] do
    collection do
      get 'payments'
      post 'creditcard_regist'
    end
  end
  resources :carts
  resources :categories do
    collection do
      get 'admin_category'
    end
  end

  resources :carts, only: [:index, :show, :destroy, :edit, :update, :create]

end
