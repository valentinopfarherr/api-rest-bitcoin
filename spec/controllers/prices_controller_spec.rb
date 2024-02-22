# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PricesController, type: :controller do
  describe 'GET #bitcoin_price' do
    context 'when CoindeskService fetches bitcoin price successfully' do
      before do
        allow(CoindeskService).to receive(:fetch_bitcoin_price).and_return(10_000.50)
        get :bitcoin_price
      end

      it 'returns a JSON response with the bitcoin price in USD' do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to start_with('application/json')
        expect(JSON.parse(response.body)['bitcoin_price']).to eq '1 bitcoin is equal to 10000.5 USD'
      end
    end
  end
end
