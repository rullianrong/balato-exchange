require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it "is valid with valid attributes and must belong to a user" do 
    transaction = build(:transaction)
    expect(transaction).to be_valid
  end

  it 'is not valid without a symbol' do 
    transaction = build(:transaction, symbol: nil)
    expect(transaction).to_not be_valid
  end

  it 'is not valid without a stock name' do
    transaction = build(:transaction, stock_name: nil)
    expect(transaction).to_not be_valid
  end

  it 'is not valid without shares' do
    transaction = build(:transaction, shares: nil)
    expect(transaction).to_not be_valid
  end

  it 'only accepts positive shares' do
    transaction = build(:transaction, shares: -100)
    expect(transaction).to_not be_valid
  end

  it 'is not valid without transaction type' do
    transaction = build(:transaction, transaction_type: nil)
    expect(transaction).to_not be_valid
  end

  it 'is not valid without the amount' do
    transaction = build(:transaction, amount: nil)
    expect(transaction).to_not be_valid
  end
end
