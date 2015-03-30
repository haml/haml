Rails.application.routes.draw do
  root to: 'application#index'

  resources :users, only: :index do
    collection do
      get :capture
      get :capture_haml
      get :form
      get :helpers
      get :safe_buffer
    end
  end
end
