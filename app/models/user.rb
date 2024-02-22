# frozen_string_literal: true

class User < ApplicationRecord
  after_create :create_default_wallets

  has_secure_password

  has_many :wallets, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, :password_confirmation, presence: true, on: :create
  validate :validate_wallets_count

  private

  def create_default_wallets
    Wallet.create(user_id: id, currency: 'USD', balance: 0)
    Wallet.create(user_id: id, currency: 'BTC', balance: 0)
  end

  def validate_wallets_count
    return unless wallets.size > 2

    errors.add(:wallets, 'cannot have more than 2 wallets')
  end
end
