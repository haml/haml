Rails.application.routes.draw do
  resources :users do
    collection do
      get :test
    end
  end
  root to: 'users#index'
end
