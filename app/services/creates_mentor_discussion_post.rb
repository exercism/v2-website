class CreatesMentorDiscussionPost < CreatesDiscussionPost
  def self.create!(*args)
    new(*args).create!
  end

  attr_reader :iteration, :user, :content, :discussion_post
  def initialize(iteration, user, content)
    @iteration = iteration
    @user = user
    @content = content
  end

  # Note: This whole method is pretty racey.
  # I'm relunctant to do locking because I'd rather avoid the
  # pain of deadlocks and slowdowns for the occasional missed
  # notification etc.
  def create!
    return false unless user_may_comment?

    create_discussion_post!

    mentorship = CreatesSolutionMentorship.create(solution, user)
    solution.update!(last_updated_by_mentor_at: DateTime.now)
    mentorship.update!(requires_action: false)
    notify_solution_user

    discussion_post
  end

  private

  def notify_solution_user
    CreatesNotification.create!(
      solution.user,
      :new_discussion_post,
      "#{solution.user.name} has commented on your solution",
      "http://foobar123.com", # TODO

      # We want this to be the solution not the post
      # to allow for clearing without a mentor having to
      # go into every single iteration
      about: solution
    )
    DeliversEmail.deliver!(
      solution.user,
      :new_discussion_post,
      discussion_post
    )
  end

  def user_may_comment?
    user.mentoring_track?(solution.exercise.track)
  end

  def html
    @html ||= ParsesMarkdown.parse(content)
  end

  def solution
    iteration.solution
  end
end
