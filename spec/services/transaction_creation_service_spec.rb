# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionCreationService do
  let(:user) { create(:user) }
  let(:sender_wallet) { user.wallets.find_by(currency: 'USD') }
  let(:receiver_wallet) { user.wallets.find_by(currency: 'BTC') }
  let(:transaction_params) { { currency_sent: 'USD', amount_sent: 500, currency_received: 'BTC' } }

  describe '#create_transaction' do
    context 'when everything is valid' do
      before do
        allow(CoindeskService).to receive(:fetch_bitcoin_price).and_return(45_000)
        sender_wallet.update(balance: 1000)
        receiver_wallet.update(balance: 0)
      end

      it 'creates a transaction and updates balances' do
        expect do
          described_class.new(user, transaction_params).create_transaction
        end.to change(Transaction, :count).by(1)
                                          .and change { sender_wallet.reload.balance }.by(-500)
                                                                                      .and change { receiver_wallet.reload.balance }.by(be_within(0.001).of(500.to_f / 45_000))
      end
    end

    context 'when sender wallet is not found' do
      before do
        transaction_params[:currency_sent] = 'EUR'
      end

      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          described_class.new(user, transaction_params).create_transaction
        end.to raise_error(ActiveRecord::RecordNotFound, 'sender wallet not found')
      end
    end

    context 'when receiver wallet is not found' do
      before do
        transaction_params[:currency_received] = 'ETH'
      end

      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          described_class.new(user, transaction_params).create_transaction
        end.to raise_error(ActiveRecord::RecordNotFound, 'receiver wallet not found')
      end
    end

    context 'when sender wallet has insufficient balance' do
      before do
        sender_wallet.update(balance: 100)
      end

      it 'raises StandardError' do
        expect do
          described_class.new(user, transaction_params).create_transaction
        end.to raise_error(StandardError, 'insufficient balance in the USD wallet')
      end
    end
  end
end
