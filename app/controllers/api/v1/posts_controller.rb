module Api
  module V1
    class PostsController < ApplicationController
      respond_to :json

      def index
        posts = Post.post_order.paginate(params[:page])
        respond_with posts
      end
    end
  end
end
