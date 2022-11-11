class RemoveValueFromTransactions < ActiveRecord::Migration[6.1]
  def change
    remove_column :transactions, :value, :float
  end
end
