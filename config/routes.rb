Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root to: 'home#index'

  resources :posts, only: [:index]

  namespace :api do
    namespace :v1, format: 'json' do
      resources :posts, only: [:index]
    end
  end
end
