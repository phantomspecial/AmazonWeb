Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root "stocks#index"

  resources :stocks
  resources :items do
    collection do
      get 'addto'
    end
  end
  resources :orders

end
