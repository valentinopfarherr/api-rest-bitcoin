# frozen_string_literal: true

FactoryBot.define do
  factory :wallet do
    association :user
    currency { %w[USD BTC].sample }
    balance { rand(0..1000) }
  end
end
