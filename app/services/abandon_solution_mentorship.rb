class AbandonSolutionMentorship
  include Mandate

  initialize_with :solution_mentorship, :message_type

  def call
    return if solution_mentorship.abandoned?

    create_system_discussion_post
    solution_mentorship.update!(abandoned: true)
    CacheSolutionNumMentors.(solution)
  end

  def create_system_discussion_post
    return if message_type === nil

    i18n_message = case message_type
      when :timed_out
        'system_messages.mentor_timed_out'
      when :left_conversation
        'system_messages.mentor_left_conversation'
      else
        raise "Unknown message type"
      end

    # Content is maintained in a JSON format so that this HTML can be
    # regenerated later if the message content changes
    content = {i18n_message: i18n_message, handle: solution_mentorship.user.handle}.to_json
    interpolated_message = I18n.t(i18n_message, handle: solution_mentorship.user.handle)

    DiscussionPost.create!(
      iteration: solution.iterations.last,
      user: User.system_user,
      content: content,
      html: ParseMarkdown.(interpolated_message)
    )
  end

  private
  def solution
    solution_mentorship.solution
  end
end

