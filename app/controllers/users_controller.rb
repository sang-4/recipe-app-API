class UsersController < ApplicationController
    def create
        user =  User.create!(user_params)
        render json: user
    end

    def index
        users = User.all
        render json: users
    end

    def show
        user = find_user
        render json: user
    end

    def update
        user = find_user
        user.update!(user_params)
        render json: user
    end

    def logout
        user = find_user
        user.destroy
        head :no_content
    end

    private 

    def user_params
        params.permit(:first_name,:last_name,:username,:email,:user_type,:password)
    end

    def find_user
        User.find(params[:id])
    end

    def render_not_found_response
        render json: { error: "User not found" }, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    end

end
