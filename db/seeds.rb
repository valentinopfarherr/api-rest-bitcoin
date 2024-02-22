admin_user = User.find_or_create_by(email: 'usertest@gmail.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end

admin_user.wallets.find_or_create_by(currency: 'USD') do |wallet|
  wallet.balance = 1000
end

admin_user.wallets.find_or_create_by(currency: 'BTC') do |wallet|
  wallet.balance = 0.0001
end

5.times do
  currency_options = ['USD', 'BTC']
  currency_sent = currency_options.sample
  currency_received = (currency_options - [currency_sent]).sample

  admin_user.transactions.create!(
    currency_sent: currency_sent,
    currency_received: currency_received,
    amount_sent: rand(1..100),
    amount_received: rand(1..100)
  )
end