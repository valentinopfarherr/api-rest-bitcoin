# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionHelper, type: :helper do
  describe '#format_transaction' do
    let(:transaction) do
      instance_double(
        'Transaction',
        id: 1,
        currency_sent: 'USD',
        currency_received: 'BTC',
        amount_sent: 100.0,
        amount_received: 0.003,
        created_at: Time.zone.local(2024, 2, 22, 10, 30, 0)
      )
    end

    it 'formats the transaction data correctly' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      formatted_transaction = helper.format_transaction(transaction)
      expect(formatted_transaction[:id]).to eq(1)
      expect(formatted_transaction[:currency_sent]).to eq('USD')
      expect(formatted_transaction[:currency_received]).to eq('BTC')
      expect(formatted_transaction[:amount_sent]).to eq('100')
      expect(formatted_transaction[:amount_received]).to eq('0.003')
      expect(formatted_transaction[:created_at]).to eq('2024-02-22 10:30:00')
    end
  end

  describe '#format_amount' do
    it 'formats USD amount correctly' do
      formatted_amount = helper.format_amount(100.0, 'USD')
      expect(formatted_amount).to eq('100')
    end

    it 'formats BTC amount correctly' do
      formatted_amount = helper.format_amount(0.003, 'BTC')
      expect(formatted_amount).to eq('0.003')
    end

    it 'does not format other currencies' do
      formatted_amount = helper.format_amount(50.0, 'EUR')
      expect(formatted_amount).to eq('50.0')
    end
  end
end
