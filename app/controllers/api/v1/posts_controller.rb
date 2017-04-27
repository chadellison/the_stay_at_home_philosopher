module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_with_token, only: [:create]
      respond_to :json

      def index
        respond_with Post.include_users(Post.post_order.paginate(params[:page]))
      end

      def show
        post = Post.find(params[:id])
        render json: Post.serialize_post(post)
      end

      def create
        post = @user.posts.new(post_params)

        if post.save
          render json: Post.serialize_post(post), status: 201
        else
          errors = post.errors.map { |key, value| "#{key} #{value}" }.join("\n")
          render json: { errors: errors }, status: 400
        end
      end

      private

      def post_params
        params.require(:post).permit(:title, :body)
      end

      def authenticate_with_token
        @user = User.find_by(encrypted_password: params[:token])
        render json: { errors: "Invalid Credentials" }, status: 401 if @user.nil?
        return if @user.nil?
      end
    end
  end
end
