Rails.application.routes.draw do
  root to: 'application#index'

  resources :users, only: :index
end
