class UsersController < ApplicationController
    def index
        @users = User.all
        render json: @users, status: 200
    end

    def show
        @user = User.find(params[:id])
        render json: @user, status: 200
    end 

    def create
        puts JSON.pretty_generate(user_params)

        new_user = User.create!(user_params)
        render json: new_user, status: :created
    end

    def update
        @user = User.find(params[:id])
        @user.update(user_params)
        render json: @user, status: 200
    end

    private

    def user_params
        params.require(:user).permit(:id, :first_name, :last_name, :username, :email, :password_digest)

    end
end
