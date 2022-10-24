class SessionsController < ApplicationController
    skip_before_action :authorize, only: :login

    def login
        user = User.find_by(username: params[:params[:username]])
        if user&.authenticate(params[:password])
            session[:current_user] = user.id
            render json: user, status: :ok
        else
            render json: {error: ["Invalid username/password combinations. Please try again!"] }, status: :unauthorized
        end
    end

    def logout
        session.delete :current_user
    end
end
