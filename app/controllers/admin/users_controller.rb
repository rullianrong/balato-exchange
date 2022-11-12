class Admin::UsersController < ApplicationController
    before_action :check_if_admin

    def index
        @users = User.all
    end

    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)

        respond_to do |format|
            if @user.save
              format.html { redirect_to user_url(@user), notice: "User was successfully created." }
              format.json { render :show, status: :created, location: @user }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end
 

  
    private
  
    def check_if_admin
        redirect_to transactions_path unless current_user.admin?
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(params[:id])
    end
  
    # Only allow a list of trusted parameters through.
    def user_params
        params.require(:user).permit(:email, :password)
    end
  end