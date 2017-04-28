module Api
  module V1
    class CommentsController < BaseController
      before_action :authenticate_with_token, only: [:create]
      respond_to :json

      def index
        comments = Post.find(params[:post_id]).comments
                       .order_and_limit.paginate(params[:page])
        render json: { data: comments.map(&:serialize_comment) }
      end

      def create
        comment = @user.comments.new(comment_params)

        if comment.save
          render json: comment.serialize_comment, status: 201
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
