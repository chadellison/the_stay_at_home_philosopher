module Api
  module V1
    class PostsController < BaseController
      respond_to :json

      def index
        respond_with Post.include_users(Post.post_order.paginate(params[:page]))
      end

      def create
        post = current_user.posts.new(post_params)

        if post.save
          render json: post, location: nil, status: 201
        else
          errors = post.errors.map { |key, value| "#{key} #{value}" }.join("\n")
          render json: { errors: errors }, status: 400
        end
      end

      private

      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end
