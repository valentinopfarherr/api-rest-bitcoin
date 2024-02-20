# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    association :user
    currency_sent { %w[USD BTC].sample }
    currency_received { %w[USD BTC].sample }
    amount_sent { rand(1..100) }
    amount_received { rand(0.01..1.00).round(8) }
    created_at { Time.current }
  end
end
