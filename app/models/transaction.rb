class Transaction < ApplicationRecord
  validates :symbol, :stock_name, :shares, :transaction_type, :amount, presence: true

  belongs_to :user
end
