Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        delete :destroy_file
      end
    end
    member do
      patch :choose_best_answer
      delete :destroy_file
    end
  end
end
