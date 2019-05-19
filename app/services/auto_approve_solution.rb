class AutoApproveSolution
  include Mandate
  include HTMLGenerationHelpers

  initialize_with :solution

  def call
    return unless solution.use_auto_analysis?

    solution.update(approved_by: system_user)
    CompleteSolution.(solution) if solution.completed?
    create_discussion_post
    notify_solution_user
  end

  private

  def create_discussion_post
    i18n_message = 'system_messages.solution_auto_approved'

    # Content is maintained in a JSON format so that this HTML can be
    # regenerated later if the message content changes
    content = {i18n_message: i18n_message}.to_json
    interpolated_message = I18n.t(i18n_message)

    DiscussionPost.create!(
      iteration: solution.iterations.last,
      user: User.system_user,
      content: content,
      html: ParseMarkdown.(interpolated_message)
    )
  end

  def notify_solution_user
    CreateNotification.(
      solution.user,
      :solution_approved,
      "Your solution to #{strong solution.exercise.title} on the #{strong solution.exercise.track.title} track has been automatically approved.",
      routes.my_solution_url(solution),
      trigger: system_user,
      about: solution
    )

    DeliverEmail.(
      solution.user,
      :solution_approved,
      solution
    )
  end

  memoize
  def system_user
    User.system_user
  end
end
