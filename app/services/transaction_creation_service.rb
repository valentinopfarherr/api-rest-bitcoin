# frozen_string_literal: true

class TransactionCreationService
  def initialize(user, transaction_params)
    @user = user
    @transaction_params = transaction_params
  end

  def create_transaction
    @transaction = @user.transactions.build(@transaction_params)
    sender_wallet = find_wallet(@transaction_params[:currency_sent].upcase)
    receiver_wallet = find_wallet(@transaction_params[:currency_received].upcase)

    raise ActiveRecord::RecordNotFound, 'sender wallet not found' unless sender_wallet
    raise ActiveRecord::RecordNotFound, 'receiver wallet not found' unless receiver_wallet

    raise StandardError, "insufficient balance in the #{@transaction_params[:currency_sent].upcase} wallet" unless sender_wallet.sufficient_balance?(@transaction_params[:amount_sent].to_f)

    @transaction.amount_received = calculate_amount_received
    raise StandardError, "error saving transaction: #{@transaction.errors.full_messages.join(', ')}" unless @transaction.save

    update_user_balances(sender_wallet, receiver_wallet)
    @transaction
  end

  private

  def find_wallet(currency)
    @user.wallets.find_by(currency: currency)
  end

  def calculate_amount_received
    if @transaction_params[:currency_sent].upcase == 'USD' && @transaction_params[:currency_received].upcase == 'BTC'
      bitcoin_price_usd = CoindeskService.fetch_bitcoin_price
      @transaction_params[:amount_sent].to_f / bitcoin_price_usd
    elsif @transaction_params[:currency_sent].upcase == 'BTC' && @transaction_params[:currency_received].upcase == 'USD'
      bitcoin_price_usd = CoindeskService.fetch_bitcoin_price
      @transaction_params[:amount_sent].to_f * bitcoin_price_usd
    else
      raise StandardError, "invalid currency conversion: #{@transaction_params[:currency_sent]} to #{@transaction_params[:currency_received]}"
    end
  rescue StandardError => e
    Rails.logger.error("Error calculating amount received: #{e.message}")
    raise StandardError, 'error calculating amount received.'
  end

  def update_user_balances(sender_wallet, receiver_wallet)
    sender_wallet.deduct(@transaction_params[:amount_sent].to_f)
    receiver_wallet.add(@transaction.amount_received)
  end
end
