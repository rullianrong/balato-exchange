class Transaction < ApplicationRecord
  validates :symbol, :stock_name, :shares, presence: true

  belongs_to :user
end
