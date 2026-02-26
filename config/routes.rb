Rails.application.routes.draw do
  devise_for :users

  # Root path
  root "pages#home"

  # Pages
  get "home", to: "pages#home"

  # Authenticated routes
  authenticated :user do
    resources :stores do
      resources :attendances, only: [:index, :create]
      get :dashboard, on: :member
    end

    resources :attendances, only: [] do
      patch :finish, on: :member
    end

    get :queue, to: "queues#show"
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
