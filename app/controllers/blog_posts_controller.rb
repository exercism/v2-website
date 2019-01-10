class BlogPostsController < ApplicationController
  def index
    @blog_posts = BlogPost.published.order('published_at DESC').page(params[:page]).per(10)
  end

  def show
    @blog_post = BlogPost.published.find(params[:id])
  end
end
