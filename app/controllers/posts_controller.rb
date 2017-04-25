class PostsController < ApplicationController
  def index
    @posts = Post.post_order.paginate(params[:page])
  end
end
