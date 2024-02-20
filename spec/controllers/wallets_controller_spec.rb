# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WalletsController, type: :controller do
  let(:user) { create(:user) }
  let(:wallet) { create(:wallet, user: user) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: { user_id: user.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { user_id: user.id, id: wallet.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #credit' do
    let(:valid_params) { { amount: '100', currency: 'USD' } }
    let(:invalid_params) { { amount: '100', currency: 'XYZ' } }

    context 'with valid parameters' do
      it 'credits the wallet and returns success message' do
        post :credit, params: { user_id: user.id, id: wallet.id, wallet: valid_params }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['message']).to include('successfully credited')
      end
    end

    context 'with invalid currency' do
      it 'returns unprocessable entity status' do
        post :credit, params: { user_id: user.id, id: wallet.id, wallet: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include('invalid currency')
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity status' do
        post :credit, params: { user_id: user.id, id: wallet.id, wallet: { amount: nil, currency: 'USD' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include('failed to credit amount to the wallet')
      end
    end
  end
end
