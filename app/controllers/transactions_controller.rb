class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]
  before_action :set_client, only: %i[ dashboard new create ]

# GET /transactio
  def index
    @transactions = current_user.transactions.order(created_at: :desc)
  end

  def dashboard
    if current_user.admin?
      redirect_to '/admin/users'
    end

    @transactions = current_user.transactions
    stock_symbols = @transactions.pluck(:symbol).uniq
    @portfolio = Array.new

    stock_symbols.each do |symbol|
      @portfolio << {
        stock: @transactions.find_by(symbol: symbol),
        shares: @transactions.where(symbol: symbol).where(transaction_type: 'buy').sum(:shares) - @transactions.where(symbol: symbol).where(transaction_type: 'sell').sum(:shares)
        # amount_bought: transactions.where(symbol: symbol).where(transaction_type: 'buy').sum(:amount), 
        # amount_sold: transactions.where(symbol: symbol).where(transaction_type: 'sell').sum(:amount)
      }
    end
  end

  def search
  end

  # GET /transactions/1 
  def show
  end

  # GET /transactions/new
  def new
      @transaction = current_user.transactions.build
      @shares = current_user.transactions.where(symbol: params[:symbol].upcase).sum(:shares)

      begin
        quote = @client.quote(params[:symbol])
        @company_name = quote.company_name
        @symbol = quote.symbol
        @price = quote.latest_price
      rescue IEX::Errors::SymbolNotFoundError
        # handle not found error
        redirect_to :search, alert: "Symbol not found"
      end

  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
    if params[:sell]
      params[:transaction][:transaction_type] = 'sell'
    else
      params[:transaction][:transaction_type] = 'buy'
    end

    params[:transaction][:amount] = params[:transaction][:shares].to_f * @client.quote(params[:transaction][:symbol]).latest_price

    @transaction = current_user.transactions.build(transaction_params)

    if @transaction.save
      redirect_to :authenticated_root, notice: 'Stocks successfully added'  
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    @stock = current_user.transactions.find_by(symbol: params[:transaction][:symbol])
    if params[:sell]
      if params[:transaction][:added_shares].to_i > @stock.shares
        redirect_to "/transactions/new?symbol=#{params[:transaction][:symbol]}&commit=Search", alert: 'Insufficient shares'
      else
        @stock.update_attribute(:shares, @stock.shares - params[:transaction][:added_shares].to_i)
        if @transaction.update(transaction_params)
          redirect_to :authenticated_root, notice: 'Stocks successfully added'
        end
      end
    else 
      @stock.update_attribute(:shares, @stock.shares + params[:transaction][:added_shares].to_i)
      if @transaction.update(transaction_params)
        redirect_to :authenticated_root, notice: 'Stocks successfully added'
      end
    end

  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to transactions_url, notice: "Transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_client
      @client = IEX::Api::Client.new
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = current_user.transactions.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:symbol, :stock_name, :shares, :transaction_type, :amount, :user_id)
    end
end
