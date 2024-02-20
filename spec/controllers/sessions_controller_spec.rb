# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    context 'with valid credentials' do
      let(:valid_params) { { email: user.email, password: 'password123' } }

      it 'returns a success response' do
        post :create, params: valid_params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('login successful')
      end
    end

    context 'with invalid credentials' do
      let(:invalid_params) { { email: user.email, password: 'wrongpassword' } }

      it 'returns an unauthorized response' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('invalid email or password')
      end
    end

    context 'with invalid email' do
      let(:invalid_params) { { email: 'nonexistent@example.com', password: 'password123' } }

      it 'returns an unauthorized response' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('invalid email or password')
      end
    end
  end
end
