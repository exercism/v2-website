module BlogPostsHelper
  def blog_post_summary(blog_post)
    blog_post.marketing_copy || strip_tags(blog_post.content)[0,280]
  end
end
