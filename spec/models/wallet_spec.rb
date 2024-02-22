# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'validations' do
    it { is_expected.to validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_inclusion_of(:currency).in_array(%w[USD BTC]) }
  end

  describe 'methods' do
    let(:user) { create(:user) } # Suponiendo que tienes un factory para crear usuarios

    describe '#deduct' do
      it 'deducts the specified amount from the balance' do
        wallet = create(:wallet, user: user, balance: 100, currency: 'USD')
        wallet.deduct(50)
        expect(wallet.reload.balance).to eq(50)
      end
    end

    describe '#add' do
      it 'adds the specified amount to the balance' do
        wallet = create(:wallet, user: user, balance: 100, currency: 'USD')
        wallet.add(50)
        expect(wallet.reload.balance).to eq(150)
      end
    end

    describe '#sufficient_balance?' do
      it 'returns true if the balance is sufficient' do
        wallet = create(:wallet, user: user, balance: 100, currency: 'USD')
        expect(wallet).to be_sufficient_balance(50)
      end

      it 'returns false if the balance is insufficient' do
        wallet = create(:wallet, user: user, balance: 100, currency: 'USD')
        expect(wallet).not_to be_sufficient_balance(150)
      end
    end
  end
end
