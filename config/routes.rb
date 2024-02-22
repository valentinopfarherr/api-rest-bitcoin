# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: [:create] do
    resources :wallets, param: :currency, only: [:index] do
      member do
        post 'credit', to: 'wallets#credit'
      end
    end
    resources :transactions, only: %i[index show create]
  end

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/bitcoin_price', to: 'prices#bitcoin_price'
end
