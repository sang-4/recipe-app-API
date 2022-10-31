class UsersController < ApplicationController

    skip_before_action :authorize, only: :create
    
    before_action :authenticate_request!, only: [:index, :show, :update, :destroy
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
# rescue_from ActiveRecord::RecordInvalid, with: :record_invalid


def show
    render json: { success: true, username: @user }
end 
    
    def new
        user = User.new(cookies[:user_id])
    end

    def index
        users = User.all
        render json: users, status: 200
    end

    def show
        current_user = User.find_by(id: session[:current_user])
        render json: current_user
    end

    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    def update
        user = User.find(params[:id])
        user.update(user_params)
        render json: user, status: 200
    end

    def destroy
        user = User.find(params[:id])
        user.destroy
        render json: {message: "User deleted"}, status: 200
    end

    private

    def user_params
        params.permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
    end

    def record_not_found
        render json: {message: "User not found"}, status: 404
    end
end