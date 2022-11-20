require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it "is valid with valid attributes and must belong to a user" do
    current_user = User.new
    transaction = current_user.transactions.new(
      symbol: 'MSFT',
      stock_name: 'Microsoft',
      shares: 100,
      transaction_type: 'buy',
      amount: 1500.00
    )
    expect(transaction).to be_valid
  end

  it 'is not valid without a symbol' do 
    transaction = Transaction.new(symbol: nil)
    expect(transaction).to_not be_valid
  end

  it 'is not valid without a stock name' do
    transaction = Transaction.new(stock_name: nil)
    expect(transaction).to_not be_valid
  end

  it 'is not valid without shares' do
    transaction = Transaction.new(shares: nil)
    expect(transaction).to_not be_valid
  end

  it 'only accepts positive shares' do
    transaction = Transaction.new(shares: -100)
    expect(transaction).to_not be_valid
  end

  it 'is not valid without transaction type' do
    transaction = Transaction.new(transaction_type: nil)
    expect(transaction).to_not be_valid
  end

  it 'is not valid without the amount' do
    transaction = Transaction.new(amount: nil)
    expect(transaction).to_not be_valid
  end
end
