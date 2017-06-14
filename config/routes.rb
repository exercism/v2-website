Rails.application.routes.draw do
  devise_for :users

  resources :tracks, only: [:index, :show]
  resources :user_tracks, only: [:create]
  resources :solutions, only: [:show] do
    member do
      patch :complete
    end
  end

  root to: "pages#index"
end
