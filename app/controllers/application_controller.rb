class ApplicationController < ActionController::API
    include ActionController::Cookies
    
    rescue_from ActiveRecord::RecordNotFound, with: :render_unprocessable_entity_response
    
    before_action :authorize, only: [:create, :update, :destroy]
    
    def current_user
        User.find_by(id: session[:current_user])
    end
    
    def authorize
        current_user = User.find_by(id: session[:user_id])
        render json: {message: "You are not authorized to view this page"}, status: 401 unless current_user
    end
    
    private
    
        def render_unprocessable_entity_response(exception)
            render json: {errors: exception.record.errors.full_messages}, status: :unprocessable_entity
        end
    
    end
    
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_in) do |user_params|
        user_params.permit(:username, :email)
      end
    end
 end

