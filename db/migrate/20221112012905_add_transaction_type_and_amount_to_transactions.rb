class AddTransactionTypeAndAmountToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :transaction_type, :string
    add_column :transactions, :amount, :float
  end
end
