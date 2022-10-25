class ApplicationController < ActionController::API
    # before_action :require_login, only: [:create, :update, :destroy]
    
    # #allow users to only view a max of 3 recipes then they must login
    # before_action :login_limit, only: [:create, :update, :destroy]

    # private

    # def require_login
    #     unless session.include? :current_user
    #         render json: {message: "You are not authorized to view this page"}, status: 401
    #     end
    # end

    # def login_limit
    #     unless session.include? :current_user
    #         if Recipe.count >= 3
    #             render json: {message: "You must login to view more recipes"}, status: 401
    #         end
    #     end
    # end
end
