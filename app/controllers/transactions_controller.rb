class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]
  before_action :set_client, only: %i[ index new ]

  # GET /transactions
  def index
    @transactions = current_user.transactions      
  end

  def search
  end

  # GET /transactions/1 
  def show
  end

  # GET /transactions/new
  def new
    if current_user.transactions.exists?(symbol: params[:symbol].upcase)
      @transaction = current_user.transactions.find_by(symbol: params[:symbol].upcase)
      @quote = @client.quote(params[:symbol])
      @company_name = @transaction.stock_name
      @symbol = @transaction.symbol
      @price = @quote.latest_price
      @shares = @transaction.shares
    else
      @transaction = current_user.transactions.build

      begin
        @quote = @client.quote(params[:symbol])
        @company_name = @quote.company_name
        @symbol = @quote.symbol
        @price = @quote.latest_price
      rescue IEX::Errors::SymbolNotFoundError
        # handle not found error
        redirect_to :search, alert: "Symbol not found"
      end
      
    end
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
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
      params.require(:transaction).permit(:symbol, :stock_name, :shares, :user_id)
    end
end
