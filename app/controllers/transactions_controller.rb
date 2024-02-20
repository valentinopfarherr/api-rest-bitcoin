# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticate_user
  before_action :set_user
  before_action :set_transaction, only: [:show]

  def index
    current_user
    @transactions = @user.transactions
    render json: { transactions: format_transactions(@transactions) }, status: :ok
  end

  def create
    @transaction = @user.transactions.build(transaction_params)

    if sufficient_balance_and_save_transaction?
      render_transaction_created_response
    else
      render_transaction_error_response
    end
  end

  def show
    render json: { transaction: format_transaction(@transaction) }, status: :ok
  end

  private

  def set_user
    @user = current_user
  end

  def set_transaction
    @transaction = @user.transactions.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:currency_sent, :currency_received, :amount_sent)
  end

  def format_transactions(transactions)
    transactions.map { |transaction| format_transaction(transaction) }
  end

  def calculate_amount_received(amount_sent)
    bitcoin_price_usd = CoindeskService.fetch_bitcoin_price
    amount_sent / bitcoin_price_usd
  rescue StandardError => e
    Rails.logger.error("error calculating amount received: #{e.message}")
    raise StandardError, 'error calculating amount received.'
  end

  def update_user_balances(transaction)
    sender_wallet, receiver_wallet = determine_wallets(transaction)
    sender_wallet.deduct(transaction.amount_sent)
    receiver_wallet.add(transaction.amount_received)
  end

  def determine_wallets(transaction)
    sender_currency, receiver_currency = if transaction.currency_sent == 'USD'
                                           %w[USD BTC]
                                         else
                                           %w[BTC USD]
                                         end
    sender_wallet = @user.wallets.find_by(currency: sender_currency)
    receiver_wallet = @user.wallets.find_by(currency: receiver_currency)
    [sender_wallet, receiver_wallet]
  end

  def sufficient_balance_and_save_transaction?
    return false unless @user.sufficient_balance?(@transaction.amount_sent, 'USD')

    @transaction.amount_received = calculate_amount_received(@transaction.amount_sent)
    @transaction.save && update_user_balances(@transaction)
  end

  def render_transaction_created_response
    render json: { transaction: format_transaction(@transaction) }, status: :created
  end

  def render_transaction_error_response
    render json: { error: @transaction.errors.full_messages || 'insufficient balance in USD' }, status: :unprocessable_entity
  end
end
