class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.string :symbol
      t.string :stock_name
      t.integer :shares
      t.string :transaction_type
      t.float :price
      t.float :value
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
