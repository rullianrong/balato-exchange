class Admin::UsersController < ApplicationController
    before_action :set_user, only: %i[ show edit update destroy confirm_user]
    before_action :set_pending_users, only: %i[ index pending_signup confirm_user ]
    before_action :check_if_admin

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    @user.skip_confirmation!


    respond_to do |format|
      if @user.save
        AdminConfirmationMailer.signed_up(@user).deliver_now
        format.html { redirect_to admin_user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_user_path(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET pending users
  def pending_signup
  end

  # PATCH pending user confirmations
  def confirm_user
    if @user.update(confirmed_at: DateTime.current)
      AdminConfirmationMailer.confirmed(@user).deliver_now
      redirect_to admin_user_pending_signup_path, notice: "Successfully confirmed user"
    else
      render :pending_signup
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_pending_users
      @pending_users = User.where(confirmed_at: nil)
    end

    # For confirmation after admin confirmed
    # def user_confirmation_email
    #   AdminConfirmationMailer.confirmed(self).deliver_now
    # end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password)
    end

    def check_if_admin
        redirect_to authenticated_root_path unless current_user.admin?
    end




    # My version
    # before_action :check_if_admin
    # before_action :set_user, only: %i[ show edit update destroy ]

    # def index
    #     @users = User.all
    # end

    # def new
    #     @user = User.new
    # end
    
    # def create
    #     @user = User.new(user_params)

    #     respond_to do |format|
    #         if @user.save
    #           format.html { redirect_to user_url(@user), notice: "User was successfully created." }
    #           format.json { render :show, status: :created, location: @user }
    #         else
    #           format.html { render :new, status: :unprocessable_entity }
    #           format.json { render json: @user.errors, status: :unprocessable_entity }
    #         end
    #     end
    # end

    # def show
    # end

    # def destroy
    #     @user.destroy
    
    #     respond_to do |format|
    #       format.html { redirect_to admin_users_path, notice: "User was successfully destroyed." }
    #       format.json { head :no_content }
    #     end
    # end
 

  
    # private
  
    # def check_if_admin
    #     redirect_to transactions_path unless current_user.admin?
    # end
  
    # # Use callbacks to share common setup or constraints between actions.
    # def set_user
    #     @user = User.find(params[:id])
    # end
  
    # # Only allow a list of trusted parameters through.
    # def user_params
    #     params.require(:user).permit(:email)
    # end
  end