class CreatesDiscussionPost
  attr_reader :iteration, :user, :content, :discussion_post
  def initialize(iteration, user, content)
    @iteration = iteration
    @user = user
    @content = content
  end

  private

  def create_discussion_post!
    @discussion_post ||= DiscussionPost.create!(
      iteration: iteration,
      user: user,
      content: content,
      html: html
    )
  end

  def html
    @html ||= ParsesMarkdown.parse(content)
  end

  def solution
    iteration.solution
  end
end
