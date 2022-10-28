class UsersController < ApplicationController
    skip_before_action :authorize, only: :create

rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
# rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    
    def new
        user = User.new(cookies[:user_id])
    end

    def index
        users = User.all
        render json: users, status: 200
    end

    def show
        @user = User.find(params[:id])
        render json: @user, status: 200
    end 

    def create
        user = User.create!(user_params)
        if user.save
            render json: user, status: :created
            if params[:remember_name]
                cookies[:user_id] = user.id 
            else
                cookies.delete(:user_id)
            end
            # redirect_to user_path(user), notice: "Welcome to the site, #{user.username}!"
            else
            render json: user.errors, status: :unprocessable_entity
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
