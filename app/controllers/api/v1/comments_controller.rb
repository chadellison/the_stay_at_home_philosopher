module Api
  module V1
    class CommentsController < BaseController
      before_action :authenticate_with_token, only: [:create]
      respond_to :json

      def create
        comment = @user.comments.new(comment_params)

        if comment.save
          render json: comment.include_user, status: 201
        else
          errors = comment.errors.map { |key, value| "#{key} #{value}" }.join("\n")
          render json: { errors: errors }, status: 400
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:body, :post_id)
      end
    end
  end
end
