# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Routes', type: :routing do
  describe 'Users routes' do
    it 'routes POST /users to users#create' do
      expect(post: '/users').to route_to('users#create')
    end

    it 'routes GET /users/:user_id/wallets to wallets#index' do
      expect(get: '/users/1/wallets').to route_to('wallets#index', user_id: '1')
    end

    it 'routes POST /users/:user_id/wallets/:currency/credit to wallets#credit' do
      expect(post: '/users/1/wallets/BTC/credit').to route_to('wallets#credit', user_id: '1', currency: 'BTC')
    end

    it 'routes GET /users/:user_id/transactions to transactions#index' do
      expect(get: '/users/1/transactions').to route_to('transactions#index', user_id: '1')
    end

    it 'routes GET /users/:user_id/transactions/:id to transactions#show' do
      expect(get: '/users/1/transactions/2').to route_to('transactions#show', user_id: '1', id: '2')
    end

    it 'routes POST /users/:user_id/transactions to transactions#create' do
      expect(post: '/users/1/transactions').to route_to('transactions#create', user_id: '1')
    end
  end

  it 'routes POST /login to sessions#create' do
    expect(post: '/login').to route_to('sessions#create')
  end

  it 'routes DELETE /logout to sessions#destroy' do
    expect(delete: '/logout').to route_to('sessions#destroy')
  end

  it 'routes GET /bitcoin_price to prices#bitcoin_price' do
    expect(get: '/bitcoin_price').to route_to('prices#bitcoin_price')
  end

  it 'routes unmatched paths to errors#not_found' do
    expect(get: '/random').to route_to('errors#not_found', path: 'random')
  end
end
