class PublishSolution
  include Mandate

  initialize_with :solution

  def call
    return if solution.published?

    solution.update(
      published_at: Time.current,
      show_on_profile: true,
      allow_comments: true
    )
  end
end
