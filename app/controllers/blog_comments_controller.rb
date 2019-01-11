class BlogCommentsController < MyController
  def create
    @blog_post = BlogPost.published.find(params[:blog_post_id])
    @comment = CreateBlogComment.(@blog_post, current_user, params[:blog_comment][:content])
  end

  def update
    @comment = current_user.blog_comments.find(params[:id])
    @blog_post = @comment.blog_post

    @comment.update!(
      previous_content: [@comment.previous_content, @comment.content].compact.join("\n---\n"),
      content: blog_comment_params[:content],
      html: ParseMarkdown.(blog_comment_params[:content]),
      edited: true
    )
  end

  def destroy
    @comment = current_user.blog_comments.find(params[:id])
    @blog_post = @comment.blog_post
    @comment.update!(deleted: true)
  end

  private

  def blog_comment_params
    params.require(:blog_comment).permit(:content)
  end
end
