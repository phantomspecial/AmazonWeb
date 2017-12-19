Rails.application.routes.draw do

  root "stocks#index"

  resources :stocks
  resources :items do
    collection do
      get 'addto'
    end
  end
  resources :orders

end
