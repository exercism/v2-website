class CreatesDiscussionPost
  include HTMLGenerationHelpers

  attr_reader :iteration, :author, :content, :discussion_post
  def initialize(iteration, author, content)
    @iteration = iteration
    @author = author
    @content = content
  end

  private

  def create_discussion_post!
    @discussion_post ||= DiscussionPost.create!(
      iteration: iteration,
      user: author,
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
