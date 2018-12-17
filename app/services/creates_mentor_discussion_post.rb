class CreatesMentorDiscussionPost < CreatesDiscussionPost
  def self.create!(*args)
    new(*args).create!
  end

  attr_reader :mentor
  def initialize(iteration, mentor, content)
    @mentor = mentor
    super(iteration, mentor, content)
  end

  # Note: This whole method is pretty racey.
  # I'm relunctant to do locking because I'd rather avoid the
  # pain of deadlocks and slowdowns for the occasional missed
  # notification etc.
  def create!
    return false unless mentor_may_comment?

    create_discussion_post!

    mentorship = CreateSolutionMentorship.(solution, mentor)
    solution.update!(last_updated_by_mentor_at: Time.current)
    mentorship.update!(requires_action_since: nil)
    notify_solution_user

    discussion_post
  end

  private

  def notify_solution_user
    CreateNotification.call(
      solution.user,
      :new_discussion_post,
      "#{strong mentor.handle} has commented on your solution to #{strong solution.exercise.title} on the #{strong solution.exercise.track.title} track.",
      routes.my_solution_iteration_url(solution, iteration),
      trigger: discussion_post,

      # We want this to be the solution not the post
      # to allow for clearing without a mentor having to
      # go into every single iteration
      about: iteration
    )

    DeliverEmail.(
      solution.user,
      :new_discussion_post,
      discussion_post
    )
  end

  def mentor_may_comment?
    mentor.mentoring_track?(solution.exercise.track)
  end

  def html
    @html ||= ParseMarkdown.(content)
  end

  def solution
    iteration.solution
  end
end
