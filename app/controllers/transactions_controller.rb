class TransactionsController < ApplicationController
  # before_action :set_transaction, only: %i[ show edit update destroy ]
  before_action :set_client, only: %i[ dashboard new create ]

# GET /transactions
  def index
    @transactions = current_user.transactions.order(created_at: :desc)
  end

  # def dashboard
  #   if current_user.admin?
  #     redirect_to '/admin/users'
  #   end

  #   stock_symbols = @transactions.pluck(:symbol).uniq
  #   @transactions = current_user.transactions
  #     .order(created_at: :desc)
  # end

  def dashboard
    @portfolio = Array.new
    transactions = current_user.transactions
    # iterate through the symbols column, returning a unique array of symbols
    stock_symbols = transactions.pluck(:symbol).uniq

    stock_symbols.each do |symbol|
      set_current_shares(transactions.where(symbol: symbol))
      stock_info = transactions.find_by(symbol: symbol)

      @portfolio << {
        symbol: stock_info.symbol,
        stock_name: stock_info.stock_name,
        current_shares: @current_shares # instance var from set_current_shares helper
      }
    end
  end

  # GET /transactions/1 
  # def show
  # end

  # GET /transactions/new
  def new
    begin
      quote = @client.quote(params[:symbol])
      @company_name = quote.company_name
      @symbol = quote.symbol
      @price = quote.latest_price
    rescue IEX::Errors::SymbolNotFoundError
      # handle symbol not found error
      redirect_to :search, alert: "Symbol not found"
    end

    @transaction = current_user.transactions.build
    stock = current_user.transactions
      .where(symbol: params[:symbol].upcase)

    set_current_shares(stock)
  end

  # GET /transactions/1/edit
  # def edit
  # end

  # POST /transactions or /transactions.json
  def create
    stock = current_user.transactions.where(symbol: params[:transaction][:symbol].upcase)

    set_current_shares(stock)

    if params[:sell] 
      if params[:transaction][:shares].to_i > @current_shares # instance var from set_current_shares helper
        redirect_to "/transactions/new?symbol=#{params[:transaction][:symbol]}&commit=Search", alert: 'Insufficient shares!' and return
      end

      params[:transaction][:transaction_type] = 'sell' 
    else
      params[:transaction][:transaction_type] = 'buy'
    end

    #computes total amount of the transaction
    params[:transaction][:amount] = params[:transaction][:shares].to_f * @client.quote(params[:transaction][:symbol]).latest_price
    @transaction = current_user.transactions.build(transaction_params)

    if @transaction.save
      redirect_to :authenticated_root, notice: 'Transaction successful!'
    else
      redirect_to "/transactions/new?symbol=#{params[:transaction][:symbol]}&commit=Search", alert: 'Invalid input!'
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  # def update
  # end

  # DELETE /transactions/1 or /transactions/1.json
  # def destroy
  #   @transaction.destroy

  #   respond_to do |format|
  #     format.html { redirect_to transactions_url, notice: "Transaction was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  private
    #initialize IEX client
    def set_client
      @client = IEX::Api::Client.new
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = current_user.transactions.find(params[:id])
    end

    # current_shares helper
    def set_current_shares(stock)
      total_bought_shares = stock.where(transaction_type: 'buy').sum(:shares)
      total_sold_shares = stock.where(transaction_type: 'sell').sum(:shares)
      @current_shares = total_bought_shares - total_sold_shares
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:symbol, :stock_name, :shares, :transaction_type, :amount, :user_id)
    end
end
