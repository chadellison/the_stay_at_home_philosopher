Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root to: 'home#index'

  resources :posts, only: [:show]

  namespace :api do
    namespace :v1, format: 'json' do
      resources :posts, only: [:index, :create]
      resources :comments, only: [:index, :create]
    end
  end
end
