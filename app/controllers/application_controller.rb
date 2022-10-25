class ApplicationController < ActionController::API
    before_action :require_login

    private

    def require_login
        unless session.include? :current_user
            render json: {message: "You are not authorized to view this page"}, status: 401
        end
    end
end
