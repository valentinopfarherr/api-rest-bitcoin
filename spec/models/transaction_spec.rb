# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:transaction_type) }
    it { is_expected.to validate_presence_of(:btc_amount) }
    it { is_expected.to validate_presence_of(:usd_amount) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
