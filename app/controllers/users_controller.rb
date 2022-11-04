class UsersController < ApplicationController
    skip_before_action :authorize, only: :create

    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        users = User.all
        render json: users
    end

    def show
        @current_user = User.find_by(session[:user_id])
        render json: @current_user
    end

    def create
        @user = User.create!(user_params)
        if @user.save
            #deliver the email
            UserNotifierMailer.send_signup_email(@user).deliver
            render json: @user, status: :created
            # redirect_to(@user, notice: 'User was successfully created.')
        session[:user_id] = @user.id
        else
        render :action => 'new'
        end
    end


    def update
        user = User.find_by(params[:id])
        user.update!(user_params)
        render json: user, status: :accepted
    end

    def destroy
        user = User.find(params[:id])
        user.destroy
        render json: {message: "User deleted"}, status: :ok
    end

    private
    def user_params
        params.permit(:firstname, :lastname, :email, :username, :password, :password_confirmation)
    end
end
