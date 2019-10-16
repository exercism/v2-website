class CreatesDiscussionPost
  include HtmlGenerationHelpers

  attr_reader :iteration, :author, :content, :type, :discussion_post
  def initialize(iteration, author, content, type: nil)
    @iteration = iteration
    @author = author
    @content = content
    @type = type
  end

  private

  def create_discussion_post!
    @discussion_post ||= DiscussionPost.create!(
      iteration: iteration,
      user: author,
      content: content,
      html: html,
      type: type
    )
  end

  def html
    @html ||= ParseMarkdown.(content)
  end

  def solution
    iteration.solution
  end
end
