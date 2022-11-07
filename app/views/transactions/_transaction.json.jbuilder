json.extract! transaction, :id, :symbol, :stock_name, :shares, :transaction_type, :price, :value, :user_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
