# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:wallets).dependent(:destroy) }
    it { is_expected.to have_many(:transactions).dependent(:destroy) }
  end

  describe 'callbacks' do
    it 'creates default wallets after user creation' do
      user = create(:user)
      expect(user.wallets.count).to eq(2)
      expect(user.wallets.pluck(:currency)).to contain_exactly('USD', 'BTC')
    end
  end
end
