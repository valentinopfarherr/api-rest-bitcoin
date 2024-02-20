# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { user: { email: 'test@example.com', password: 'password123' } } }

      it 'creates a new user' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'returns a success message' do
        post :create, params: valid_params
        expect(JSON.parse(response.body)['message']).to eq('user created successfully')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { user: { email: '', password: '' } } }

      it 'does not create a new user' do
        expect do
          post :create, params: invalid_params
        end.not_to change(User, :count)
      end

      it 'returns an error message' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include("Email can't be blank", "Password can't be blank")
      end
    end
  end
end
