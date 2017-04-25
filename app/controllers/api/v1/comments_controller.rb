module Api
  module V1
    class CommentsController < BaseController
      respond_to :json

      def index
        respond_with Comment.include_users(Comment.comment_order.paginate(params[:page]))
      end

      def create
        comment = current_user.comments.new(comment_params)

        if comment.save
          render json: comment, location: nil, status: 201
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
