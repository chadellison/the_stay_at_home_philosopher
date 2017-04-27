module Api
  module V1
    class PostsController < BaseController
      before_action :authenticate_with_token, only: [:create]
      respond_to :json

      def index
        posts = Post.post_order.paginate(params[:page])
        respond_with Post.include_associations(posts)
      end

      def show
        render json: Post.find(params[:id]).serialize_post
      end

      def create
        post = @user.posts.new(post_params)

        if post.save
          render json: post.serialize_post, status: 201
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
