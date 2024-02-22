# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    it 'logs in the user successfully' do
      post :create, params: { session: { email: user.email, password: user.password } }

      expect(session[:user_id]).to eq(user.id)
      expect(response).to have_http_status(:ok)
    end

    it 'fails to log in the user with invalid credentials' do
      post :create, params: { session: { email: user.email, password: 'incorrect_password' } }

      expect(session[:user_id]).to be_nil
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE #destroy' do
    it 'logs out the user successfully' do
      session[:user_id] = user.id

      delete :destroy

      expect(session[:user_id]).to be_nil
      expect(response).to have_http_status(:ok)
    end

    it 'fails to log out the user if not logged in' do
      delete :destroy

      expect(session[:user_id]).to be_nil
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
