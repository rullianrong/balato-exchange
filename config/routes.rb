Rails.application.routes.draw do
  devise_for :users

  # redirection for authentication
  devise_scope :user do
    authenticated :user do
      root 'transactions#dashboard', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  namespace :admin do
    get "/user_pending_signup", to: "users#pending_signup"
    patch "/user_pending_signup/:id", to: "users#confirm_user"
    resources :users do
      resources :transactions
    end
  end

  resources :transactions
  get '/search', to: 'transactions#search', as: 'search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
