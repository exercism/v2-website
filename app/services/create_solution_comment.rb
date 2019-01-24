class CreateSolutionComment < CreatesDiscussionPost
  include Mandate

  initialize_with :solution, :user, :content

  def call
    SolutionComment.create!(
      solution: solution,
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

