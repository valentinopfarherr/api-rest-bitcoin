# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) { { email: 'test@example.com', password: 'password', password_confirmation: 'password' } }

      it 'creates a new user' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('user created successfully')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { email: 'test@example.com', password: 'password', password_confirmation: 'wrong_password' } }

      it 'does not create a new user' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to be_present
      end
    end
  end
end
