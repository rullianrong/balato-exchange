Rails.application.routes.draw do
  devise_for :users

  # redirection for authentication
  devise_scope :user do
    authenticated :user do
      root 'users#dashboard', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :transactions
  get '/search', to: 'transactions#search', as: 'search'
  get '/quote', to: 'transactions#quote', as: 'quote'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end