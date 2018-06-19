Rails.application.routes.draw do

  # TODO - Delete this
  post "tmp/create_iteration" => "tmp#create_iteration", as: :tmp_create_iteration
  post "tmp/create_team_iteration" => "tmp#create_team_iteration", as: :tmp_create_team_iteration

  # ### #
  # API #
  # ### #
  namespace :api do
    scope :v1 do
      get "ping" => "ping#index"
      get "validate_token" => "validate_token#index"

      resource :cli_settings, only: [:show]
      resources :tracks, only: [:show]
      resources :solutions, only: [:show, :update] do
        collection do
          get :latest
        end

        get 'files/*filepath', to: 'files#show', format: false, as: "file"
      end
    end
  end
  get "api/(*url)", to: 'api#render_404'

  # ##### #
  # Admin #
  # ##### #
  namespace :admin do
    resource :dashboard, only: [:show], controller: "dashboard"
  end

  # ###### #
  # Mentor #
  # ###### #
  namespace :mentor do
    resource :dashboard, only: [:show], controller: "dashboard"
    resources :solutions, only: [:show] do
      member do
        patch :approve
        patch :abandon
        patch :ignore
      end
    end
    resources :discussion_posts, only: [:create]
  end

  # #### #
  # Auth #
  # #### #
  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations',
    confirmations: 'confirmations',
    omniauth_callbacks: "omniauth_callbacks"
  }

  devise_scope :user do
    get "confirmations/required" => "confirmations#required", as: 'confirmation_required'
  end

  # ######## #
  # External #
  # ######## #
  resources :profiles, only: [:index, :show] do
    get :solutions, on: :member
  end
  resources :solutions, only: [:show]
  resources :tracks, only: [:index, :show] do
    member do
      post :join
    end
    resources :exercises, only: [:index, :show] do
      resources :solutions, only: [:index, :show]
    end
    resources :maintainers, only: [:index]
    resources :mentors, only: [:index]
  end

  # ######## #
  # Internal #
  # ######## #
  namespace :my do
    resource :dashboard, only: [:show], controller: "dashboard"

    resources :tracks, only: [:index, :show] do
      resources :side_exercises, only: [:index]
    end

    resources :user_tracks, only: [:create] do
      member do
        patch :set_normal_mode
        patch :set_independent_mode
      end
    end
    resources :solutions, only: [:show, :create] do
      member do
        get :walkthrough
        patch :request_mentoring
        get :confirm_unapproved_completion
        patch :complete
        get :reflection
        patch :reflect
        patch :publish
      end
    end
    resources :reactions, only: [:index, :create]

    resources :discussion_posts, only: [:create]
    resources :notifications, only: [:index] do
      patch :read, on: :member
      patch :read_batch, on: :collection
    end
    resource :profile, controller: "profile"

    resource :settings do
      patch :update_user_tracks
      resource :communication_preferences, only: [:edit, :update]
    end
  end

  # ##### #
  # Teams #
  # ##### #
  # namespace :teams do
  namespace :teams, path: '', constraints: { subdomain: 'teams' } do
    get "/" => "pages#index"
    get "dashboard" => "dashboard#index"

    resources :teams, only: [], param: :token do
      resource :join
    end
    resources :team_memberships, only: [:destroy]

    resources :invitations, only: [] do
      post :accept, on: :member
      post :reject, on: :member
    end

    resources :teams do
      resources :my_solutions do
        get :possible_exercises, on: :collection
      end
      resources :solutions
      resources :discussion_posts, only: [:create]
      resources :memberships, only: [:index, :destroy]
      resources :invitations, only: [:new, :create, :destroy]
    end

    Teams::PagesController::PAGES.values.each do |page|
      get page.to_s.dasherize => "pages##{page}"#, as: "teams_#{page}_page"
    end
  end

  # ##### #
  # Pages #
  # ##### #
  PagesController::PAGES.values.each do |page|
    get page.to_s.dasherize => "pages##{page}", as: "#{page}_page"
  end

  get "team" => "pages#team", as: "team_page"
  get "contributors" => "pages#contributors", as: "contributors_page"

  # ############ #
  # Weird things #
  # ############ #
  namespace :webhooks do
    resources :repo_updates, only: [:create]
    resources :contributors, only: [:create]
  end
  post "markdown/parse" => "markdown#parse"

  root to: "pages#index"
end
