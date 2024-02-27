# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

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

  match '*path', to: 'errors#not_found', via: :all
end
