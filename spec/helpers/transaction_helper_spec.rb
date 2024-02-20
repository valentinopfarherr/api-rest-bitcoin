# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionHelper, type: :helper do
  describe '#format_transaction' do
    let(:transaction) do
      instance_double(
        Transaction,
        id: 1,
        currency_sent: 'USD',
        currency_received: 'BTC',
        amount_sent: 100,
        amount_received: 0.01,
        created_at: Time.zone.local(2024, 2, 19, 10, 30, 0)
      )
    end

    it 'formats the transaction data' do # rubocop:disable RSpec/ExampleLength
      expect(helper.format_transaction(transaction)).to eq(
        {
          id: 1,
          currency_sent: 'USD',
          currency_received: 'BTC',
          amount_sent: '100.00',
          amount_received: '0.01000000',
          created_at: '2024-02-19 10:30:00'
        }
      )
    end
  end

  describe '#format_amount' do
    it 'formats USD amount' do
      expect(helper.format_amount(100, 'USD')).to eq('100.00')
    end

    it 'formats BTC amount' do
      expect(helper.format_amount(0.01, 'BTC')).to eq('0.01000000')
    end

    it 'returns amount as is for unknown currency' do
      expect(helper.format_amount(50, 'XYZ')).to eq('50')
    end
  end
end
