class Transaction < ApplicationRecord
  validates :symbol, :stock_name, :shares, :transaction_type, :amount, presence: true
  validates :shares, :numericality => { :greater_than_or_equal_to => 1 }
  belongs_to :user
end
