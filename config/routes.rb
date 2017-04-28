Rails.application.routes.draw do
  namespace :api do
    namespace :v1, format: 'json' do
      resources :posts, only: [:index, :create, :show]
      resources :comments, only: [:index, :create]
      resources :authentication, only: [:create]
      resources :users, only: [:create, :show]
    end
  end
end
