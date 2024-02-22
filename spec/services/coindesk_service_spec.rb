# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoindeskService do
  describe '.fetch_bitcoin_price' do
    let(:fake_response_body) do
      {
        'bpi' => {
          'USD' => {
            'rate' => '45000'
          }
        }
      }.to_json
    end

    before do
      allow(HTTParty).to receive(:get).and_return(double(body: fake_response_body))
    end

    it 'fetches the Bitcoin price' do
      expect(HTTParty).to receive(:get).with(ENV['COINDESK_URL'])

      bitcoin_price = described_class.fetch_bitcoin_price

      expect(bitcoin_price).to eq(45_000.0)
    end

    context 'when Coindesk API request fails' do
      before do
        allow(HTTParty).to receive(:get).and_raise(HTTParty::Error, 'Timeout error')
      end

      it 'logs an error and raises StandardError' do
        expect(Rails.logger).to receive(:error).with('error getting Bitcoin price: Timeout error')

        expect do
          described_class.fetch_bitcoin_price
        end.to raise_error(StandardError, 'error getting Bitcoin price.')
      end
    end
  end
end
