module Api
  module V1
    class PostsController < ApplicationController
      respond_to :json

      def index
        respond_with Post.include_users(Post.post_order.paginate(params[:page]))
      end

      def create

      end
    end
  end
end
