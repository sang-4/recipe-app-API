class SessionsController < ApplicationController

    require 'json_web_token'

    skip_before_action :authorize, only: :create

    def create
        user = User.find_for_database_authentication(user_id: params[:email][:password])
        if user&.authenticate(params[:password])
            session[:current_user] = user.id
            render json: payload(user, params)
        else
            render json: { errors:["Invalid username and/or password"] }, status: :unauthorized
        end
    end

    def destroy
        session.delete :user_id
        head :no_content
    end

    private

    def payload(user, params = {})
        jwt_token = user.jwt_tokens.create(token: SecureRandom.uuid)
        {
            api_key: user.api_key,
            auth_token: JsonWebToken.encode({token: jwt_token.token})
        }
    end

end
