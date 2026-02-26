Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Root path
  root "pages#home"

  # Pages
  get "home", to: "pages#home"

  # Authenticated routes
  authenticated :user do
    resources :stores do
      resources :attendances, only: [:index, :create]
      get :dashboard, on: :member
      member do
        get :queue
        post :queue_join
        delete :queue_leave
      end
    end

    resources :attendances, only: [] do
      patch :finish, on: :member
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
