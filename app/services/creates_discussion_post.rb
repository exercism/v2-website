class CreatesDiscussionPost
  def self.create!(*args)
    new(*args).create!
  end

  attr_reader :iteration, :user, :content
  def initialize(iteration, user, content)
    @iteration = iteration
    @user = user
    @content = content
  end

  def create!
    return false unless user_may_comment?

    DiscussionPost.create!(
      iteration: iteration,
      user: user,
      content: content,
      html: html
    )
  end

  def user_may_comment?
    return true if user == iteration.solution.user

    # TODO - Add mentor permissions
    return false
  end

  def html
    @html ||= ParsesMarkdown.parse(content)
  end
end
