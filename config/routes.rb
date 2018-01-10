Rails.application.routes.draw do

  devise_for :users
  root "stocks#index"

  resources :stocks do
    collection do
      get 'search'
    end
  end
  get 'stocks/autocomplete_stocks/:term' => 'stocks#autocomplete_stocks'

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
  resources :admins, only: [:index] do
    resources :userpermissions, only: [:index, :update]
  end
  resources :users, only: [:index, :show, :new] do
    collection do
      get 'payments'
      post 'creditcard_regist'
      delete 'creditcard_destroy'
    end
  end
  resources :carts
  resources :categories do
    collection do
      get 'admin_category'
    end
  resources :sub_categories
  end
  resources :carts, only: [:index, :show, :destroy, :edit, :update, :create]
end
