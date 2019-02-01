class BlogPostsController < ApplicationController
  def index
    @blog_posts = BlogPost.published.ordered_by_recency

    respond_to do |format|
      format.html do
        if params[:category].present?
          @category = params[:category]
          @blog_posts = @blog_posts.where(category: params[:category])
        else
          @category = nil
        end

        @blog_posts = @blog_posts.page(params[:page]).per(10)
        @comment_counts = BlogComment.where(blog_post_id: @blog_posts.map(&:id)).group(:blog_post_id).count
      end

      format.rss do
        render content_type: "application/rss", disposition: 'inline'
      end
    end
  end

  def show
    @blog_post = BlogPost.published.find(params[:id])
    ClearNotifications.(current_user, @blog_post)
  end
end
