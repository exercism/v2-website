class CreateBlogComment < CreatesDiscussionPost
  include Mandate

  initialize_with :blog_post, :commenter, :content

  def call
    @comment = BlogComment.create!(
      blog_post: blog_post,
      user: commenter,
      content: content,
      html: html
    )

    create_blog_post_author_notification
    create_commenter_notifications

    return comment
  end

  private
  attr_reader :comment

  def html
    ParseMarkdown.(content)
  end

  def create_blog_post_author_notification
    return unless blog_post.author
    return if blog_post.author == commenter

    CreateNotification.(
      blog_post.author,
      :new_blog_comment_for_blog_post_author,
      "Someone has commented on <strong>#{blog_post.title}</strong>",
      Rails.application.routes.url_helpers.blog_post_url(blog_post, anchor: "comment-#{comment}"),
      trigger: comment,
      about: blog_post
    )
  end

  def create_commenter_notifications
    users = blog_post.comments.map(&:user) - [commenter, blog_post.author]
    users.each do |user|
      CreateNotification.(
        user,
        :new_blog_comment_for_other_commenter,
        "Someone else has commented on #{blog_post.title}",
        Rails.application.routes.url_helpers.blog_post_url(blog_post, anchor: "comment-#{comment}"),
        trigger: comment,
        about: blog_post
      )
    end
  end

end
