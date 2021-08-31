Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy]

    member do
      patch :choose_best_answer
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
end
