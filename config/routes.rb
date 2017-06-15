Rails.application.routes.draw do
  devise_for :users

  namespace :api do
  end

  resources :tracks, only: [:index, :show]
  resources :user_tracks, only: [:create]
  resources :solutions, only: [:show] do
    member do
      patch :complete
    end
  end

  resources :discussion_posts do
  end

  root to: "pages#index"
end
