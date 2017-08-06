class CreatesUserDiscussionPost < CreatesDiscussionPost
  def self.create!(*args)
    new(*args).create!
  end

  def initialize(iteration, user, content)
    super
  end

  # Note: This whole method is pretty racey.
  # I'm relunctant to do locking because I'd rather avoid the
  # pain of deadlocks and slowdowns for the occasional missed
  # notification etc.
  def create!
    return false unless user_may_comment?

    create_discussion_post!

    solution.update!(last_updated_by_user_at: DateTime.now)
    solution.mentorships.update_all(requires_action: true)
    notify_mentors

    discussion_post
  end

  private

  def notify_mentors
    solution.mentors.each do |mentor|
      CreatesNotification.create!(
        mentor,
        :new_discussion_post_for_mentor,
        "#{solution.user.name} has posted a comment on a solution you are mentoring",
        routes.mentor_solution_url(solution),

        # We want this to be the solution not the post
        # to allow for clearing without a mentor having to
        # go into every single iteration
        about: solution
      )
      DeliversEmail.deliver!(
        mentor,
        :new_discussion_post_for_mentor,
        discussion_post
      )
    end
  end

  def user_may_comment?
    user == solution.user
  end

  def routes
    @routes ||= Rails.application.routes.url_helpers
  end
end
