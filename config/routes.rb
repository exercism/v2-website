Rails.application.routes.draw do
  devise_for :users

  resources :tracks, only: [:index, :show]
  resources :user_tracks, only: [:create]

  root to: "pages#index"

end
