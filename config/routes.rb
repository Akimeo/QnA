require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy]

    member do
      patch :choose_best_answer
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
  resources :votes, only: %i[create destroy]
  resources :comments, only: :create
  resources :subscriptions, only: %i[create destroy]

  mount ActionCable.server => '/cable'
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
