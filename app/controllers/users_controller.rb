class UsersController < ApplicationController
    skip_before_action :authorize, only: :create

rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
# rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    def index
        @users = User.all
        render json: @users, status: 200
    end

    def show
        @user = User.find(params[:id])
        render json: @user, status: 200
    end 

    def create
        user = User.create!(user_params)

        session[:user_id] = user.id
        render json: user, status: :created
        
    end

    def update
        @user = User.find(params[:id])
        @user.update(user_params)
        render json: @user, status: 200
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        render json: {message: "User deleted"}, status: 200
    end

    private

    def user_params

        params.permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
    end

    def record_not_found
        render json: {message: "User not found"}, status: 404
    end

    # def record_invalid
    #     render json: {message: "All fields MUST be filled"}, status: 422
    # end

    # def skip_before_action
    #     render json: {message: "You are not authorized to view this page"}, status: 401
    # end
end
