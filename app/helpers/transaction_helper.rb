# frozen_string_literal: true

module TransactionHelper
  def format_transaction(transaction)
    {
      id: transaction.id,
      currency_sent: transaction.currency_sent,
      currency_received: transaction.currency_received,
      amount_sent: format_amount(transaction.amount_sent, transaction.currency_sent),
      amount_received: format_amount(transaction.amount_received, transaction.currency_received),
      created_at: transaction.created_at.strftime('%Y-%m-%d %H:%M:%S')
    }
  end

  def format_amount(amount, currency)
    if currency == 'USD'
      format('%.2f', amount)
    elsif currency == 'BTC'
      format('%.8f', amount)
    else
      amount.to_s
    end
  end
end
