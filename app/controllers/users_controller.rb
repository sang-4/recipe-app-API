class UsersController < ApplicationController
    before_action :require_login, only: [:index, :show, :update, :destroy]

rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    def index
        @users = User.all
        render json: @users, status: 200
    end

    def show
        @user = User.find(params[:id])
        render json: @user, status: 200
    end 

    # def create
    #     puts JSON.pretty_generate(user_params)
    #     new_user = User.create!(user_params)
    #     render json: new_user, status: :created
    # end

    def create
        @user = User.create(user_params)
        if @user.valid?
             session[:user_id] = @user.id
        else
            render json: { error: 'failed to create user' }, status: :unprocessable_entity
        end
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
        params.require(:user).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
    end

    def record_not_found
        render json: {message: "User not found"}, status: 404
    end

    def record_invalid
        render json: {message: "All fields MUST be filled"}, status: 422
    end

    def before_action
        render json: {message: "You are not authorized to view this page"}, status: 401
    end
end
