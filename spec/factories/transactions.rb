FactoryBot.define do
  factory :transaction do
    symbol {'MSFT'}
    stock_name {'Microsoft'}
    shares {100}
    transaction_type {'buy'}
    amount {9500.0}
    association :user
  end
end
