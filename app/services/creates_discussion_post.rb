class CreatesDiscussionPost
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

    # TODO - Some of this should be moved to backend job
    if posted_by_solution_user?
      solution.update!(last_updated_by_user_at: DateTime.now)
      solution.mentorships.update_all(requires_action: true)
      notify_mentors
    else
      mentorship = CreatesSolutionMentorship.create(solution, user)
      solution.update!(last_updated_by_mentor_at: DateTime.now)
      mentorship.update!(requires_action: false)
      notify_solution_user
    end

    discussion_post
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

  def notify_mentors
    solution.mentors.each do |mentor|
      CreatesNotification.create!(
        mentor,
        :new_discussion_post_for_mentor,
        "#{solution.user.name} has posted a comment on a solution you are mentoring",
        "http://foobar.com", # TODO
        about: discussion_post
      )
      DeliversEmail.deliver!(
        mentor,
        :new_discussion_post_for_mentor,
        discussion_post
      )
    end
  end

  def notify_solution_user
    CreatesNotification.create!(
      solution.user,
      :new_discussion_post,
      "#{solution.user.name} has commented on your solution",
      "http://foobar123.com", # TODO
      about: discussion_post
    )
    DeliversEmail.deliver!(
      solution.user,
      :new_discussion_post,
      discussion_post
    )
  end

  def user_may_comment?
    return true if posted_by_solution_user?

    # TODO - Add mentor permissions
    return true
  end

  def posted_by_solution_user?
    user == solution.user
  end

  def html
    @html ||= ParsesMarkdown.parse(content)
  end

  def solution
    iteration.solution
  end
end
