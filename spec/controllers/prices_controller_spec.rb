# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PricesController, type: :controller do
  describe 'GET #bitcoin_price' do
    context 'when CoindeskService successfully fetches the bitcoin price' do
      let(:bitcoin_price) { 45_000.0 }

      before do
        allow(CoindeskService).to receive(:fetch_bitcoin_price).and_return(bitcoin_price)
        get :bitcoin_price
      end

      it 'returns HTTP success' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the bitcoin price in JSON format' do
        expect(JSON.parse(response.body)).to eq({ 'bitcoin_price' => bitcoin_price })
      end
    end

    context 'when CoindeskService encounters an error while fetching the bitcoin price' do
      before do
        allow(CoindeskService).to receive(:fetch_bitcoin_price).and_raise(StandardError, 'Error fetching bitcoin price')
        get :bitcoin_price
      end

      it 'returns HTTP internal server error' do
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'returns an error message in JSON format' do
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Error fetching bitcoin price' })
      end
    end
  end
end
