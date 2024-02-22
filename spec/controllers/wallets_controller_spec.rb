# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WalletsController, type: :controller do
  let(:user) { create(:user) }
  let(:wallet) { create(:wallet, user: user) }

  describe 'GET #index' do
    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end

      it 'returns a list of wallets' do
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('wallets')
      end
    end

    context 'when user is not logged in' do
      it 'returns unauthorized status' do
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #credit' do
    let(:valid_params_usd) { { user_id: user.id, amount: 100, currency: 'USD' } }
    let(:valid_params_btc) { { user_id: user.id, amount: 0.01, currency: 'BTC' } }
    let(:invalid_params) { { user_id: user.id, amount: -50, currency: 'ABC' } }

    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end

      context 'with valid parameters for USD' do
        it 'credits the wallet' do
          post :credit, params: valid_params_usd
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to include('message', 'wallet')
        end
      end

      context 'with valid parameters for BTC' do
        it 'credits the wallet' do
          post :credit, params: valid_params_btc
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to include('message', 'wallet')
        end
      end

      context 'with invalid parameters' do
        it 'returns an error message' do
          post :credit, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include('error')
        end
      end
    end

    context 'when user is not logged in' do
      it 'returns unauthorized status' do
        post :credit, params: valid_params_usd
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
