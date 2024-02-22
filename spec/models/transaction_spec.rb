# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:currency_sent) }
    it { is_expected.to validate_presence_of(:currency_received) }
    it { is_expected.to validate_inclusion_of(:currency_sent).in_array(%w[USD usd BTC btc]) }
    it { is_expected.to validate_inclusion_of(:currency_received).in_array(%w[USD usd BTC btc]) }
    it { is_expected.to validate_presence_of(:amount_sent) }
    it { is_expected.to validate_numericality_of(:amount_sent).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
