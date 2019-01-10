class BlogPostsController < ApplicationController
  def index
    @blog_posts = BlogPost.published.order('published_at DESC')

    respond_to do |format|
      format.html do
        @blog_posts = @blog_posts.page(params[:page]).per(10)
      end

      format.rss do
        render content_type: "application/rss", disposition: 'inline'
      end
    end
  end

  def show
    @blog_post = BlogPost.published.find(params[:id])
  end
end
