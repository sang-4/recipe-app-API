class CommentsController < ApplicationController
    def create
        comment =  Comment.create!(comment_params)
        render json: comment
    end

    def index
        comment = Comment.all
        render json: comment
    end

    def show
        comment = find_comment
        render json: comment
    end

    def update
        comment = find_comment
        comment.update!(comment_params)
        render json: comment
    end

    def logout
        comment = find_comment
        comment.destroy
        head :no_content
    end

    private 

    def comment_params
        params.permit(:user_id,:content,:image_url)
    end

    def find_comment
        Comment.find(params[:id])
    end

    def render_not_found_response
        render json: { error: "Comment not found" }, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    end

end


