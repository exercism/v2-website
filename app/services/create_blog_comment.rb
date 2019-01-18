class CreateBlogComment < CreatesDiscussionPost
  include Mandate

  initialize_with :blog_post, :user, :content

  def call
    BlogComment.create!(
      blog_post: blog_post,
      user: user,
      content: content,
      html: html
    )
  end

  private
  
  def html
    ParseMarkdown.(content)
  end
end
