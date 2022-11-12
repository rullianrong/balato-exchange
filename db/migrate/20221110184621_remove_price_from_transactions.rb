class RemovePriceFromTransactions < ActiveRecord::Migration[6.1]
  def change
    remove_column :transactions, :price, :float
  end
end
