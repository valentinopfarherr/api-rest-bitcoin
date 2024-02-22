# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:transaction) { create(:transaction, user: user) }

  describe 'GET #index' do
    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end

      it 'returns a list of transactions' do
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('transactions')
      end
    end

    context 'when user is not logged in' do
      it 'returns unauthorized status' do
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params_usd) { { user_id: user.id, transaction: { currency_sent: 'USD', currency_received: 'BTC', amount_sent: 100 } } }
    let(:valid_params_btc) { { user_id: user.id, transaction: { currency_sent: 'BTC', currency_received: 'USD', amount_sent: 0.001 } } }
    let(:invalid_params) { { user_id: user.id, transaction: { currency_sent: 'ABC', currency_received: 'ABC', amount_sent: -50 } } }

    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
        user.wallets.find_by(currency: 'USD').update(balance: 500)
        user.wallets.find_by(currency: 'BTC').update(balance: 0.005)
      end

      context 'with valid parameters for USD to BTC' do
        it 'creates a transaction from USD to BTC' do
          post :create, params: valid_params_usd
          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).to include('transaction')
        end
      end

      context 'with valid parameters for BTC to USD' do
        it 'creates a transaction from BTC to USD' do
          post :create, params: valid_params_btc
          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).to include('transaction')
        end
      end

      context 'with invalid parameters' do
        it 'returns an error message' do
          post :create, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include('error')
        end
      end
    end

    context 'when user is not logged in' do
      it 'returns unauthorized status' do
        post :create, params: valid_params_usd
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end

      it 'returns the requested transaction' do
        get :show, params: { user_id: user.id, id: transaction.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('transaction')
      end
    end

    context 'when user is not logged in' do
      it 'returns unauthorized status' do
        get :show, params: { user_id: user.id, id: transaction.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
