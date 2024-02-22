# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:wallets).dependent(:destroy) }
    it { is_expected.to have_many(:transactions).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:password).on(:create) }
    it { is_expected.to validate_presence_of(:password_confirmation).on(:create) }
  end

  describe 'creation with wallets' do
    let(:user) { create(:user) }

    it 'creates a user with wallets' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      expect(user.wallets.count).to eq(2)

      usd_wallet = user.wallets.find_by(currency: 'USD')
      btc_wallet = user.wallets.find_by(currency: 'BTC')

      expect(usd_wallet).to be_present
      expect(btc_wallet).to be_present

      expect(usd_wallet.balance).to eq(0.0)
      expect(btc_wallet.balance).to eq(0.0)
    end

    it 'is invalid with more than 2 wallets' do
      create_list(:wallet, 3, user: user)
      expect(user).not_to be_valid
      expect(user.errors[:wallets]).to include('cannot have more than 2 wallets')
    end
  end
end
