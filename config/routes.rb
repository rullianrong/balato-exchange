Rails.application.routes.draw do
  devise_for :users

  # redirection for authentication
  devise_scope :user do
    authenticated :user do
      root 'transactions#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  namespace :admin do
    resources :users
  end

  resources :transactions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
