# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: [:create] do
    resources :wallets, only: [:index] do
      post 'credit', on: :member
    end
    resources :transactions, only: %i[index show create]

    match '*path', to: 'errors#not_found', via: :all
  end

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/bitcoin_price', to: 'prices#bitcoin_price'

  match '*path', to: 'errors#not_found', via: :all
end
