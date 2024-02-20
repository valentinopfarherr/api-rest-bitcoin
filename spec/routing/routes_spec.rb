# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Routes', type: :routing do
  it 'routes POST /users to users#create' do
    expect(post: '/users').to route_to('users#create')
  end

  it 'routes GET /users/:user_id/wallets to wallets#index' do
    expect(get: '/users/1/wallets').to route_to('wallets#index', user_id: '1')
  end

  it 'routes GET /users/:user_id/wallets/:id to wallets#show' do
    expect(get: '/users/1/wallets/2').to route_to('wallets#show', user_id: '1', id: '2')
  end

  it 'routes POST /users/:user_id/wallets/:id/credit to wallets#credit' do
    expect(post: '/users/1/wallets/2/credit').to route_to('wallets#credit', user_id: '1', id: '2')
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

  it 'routes POST /login to sessions#create' do
    expect(post: '/login').to route_to('sessions#create')
  end

  it 'routes GET /bitcoin_price to prices#bitcoin_price' do
    expect(get: '/bitcoin_price').to route_to('prices#bitcoin_price')
  end
end
