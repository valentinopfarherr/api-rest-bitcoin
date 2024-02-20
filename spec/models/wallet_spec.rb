# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'validations' do
    it { is_expected.to validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_inclusion_of(:currency).in_array(%w[USD BTC]) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'methods' do
    let(:user) { create(:user) }
    let(:wallet) { create(:wallet, user: user) }

    it 'deducts amount from balance' do
      wallet.update(balance: 100)
      wallet.deduct(50)
      expect(wallet.balance).to eq(50)
    end

    it 'adds amount to balance' do
      wallet.update(balance: 100)
      wallet.add(50)
      expect(wallet.balance).to eq(150)
    end

    it 'checks if balance is sufficient for deduction' do
      wallet.update(balance: 100)
      expect(wallet.send(:sufficient_balance?, 50)).to be(true)
      expect(wallet.send(:sufficient_balance?, 150)).to be(false)
    end
  end
end
