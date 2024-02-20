# frozen_string_literal: true

require 'rails_helper'
require 'coindesk_service'

RSpec.describe CoindeskService do
  describe '.fetch_bitcoin_price' do
    context 'when Coindesk API is reachable' do
      let(:mock_response) do
        {
          'bpi' => {
            'USD' => {
              'rate' => '45000.00'
            }
          }
        }.to_json
      end

      before do
        allow(HTTParty).to receive(:get).and_return(instance_double(HTTParty::Response, body: mock_response))
      end

      it 'returns the Bitcoin price as a float' do
        expect(described_class.fetch_bitcoin_price).to eq(45_000.00)
      end
    end

    context 'when Coindesk API is unreachable' do
      before do
        allow(HTTParty).to receive(:get).and_raise(HTTParty::Error, 'API unreachable')
        allow(Rails.logger).to receive(:error)
      end

      it 'raises a StandardError' do
        expect { described_class.fetch_bitcoin_price }.to raise_error(StandardError, 'error getting Bitcoin price.')
      end
    end
  end
end
