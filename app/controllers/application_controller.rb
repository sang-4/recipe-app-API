class ApplicationController < ActionController::API
    include ActionController::Cookies

    before_action :authorize, except: [:login, :create, :index, :show]

    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    
    def current_user
        User.find_by(id: session[:user_id])
    end

    def authorize
      render json: { errors: ["Not authorized"] }, status: :unauthorized unless current_user
    end
  
    private
  
    def render_unprocessable_entity_response(invalid)
      render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
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


