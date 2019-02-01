class CreatesUserDiscussionPost < CreatesDiscussionPost
  include UserHelper

  def self.create!(*args)
    new(*args).create!
  end

  attr_reader :user
  def initialize(iteration, user, content)
    @user = user
    super(iteration, user, content)
  end

  # Note: This whole method is pretty racey.
  # I'm relunctant to do locking because I'd rather avoid the
  # pain of deadlocks and slowdowns for the occasional missed
  # notification etc.
  def create!
    return false unless user_may_comment?

    create_discussion_post!

    solution.update!(last_updated_by_user_at: Time.current)
    solution.mentorships.update_all(requires_action_since: Time.current) unless solution.approved?
    notify_mentors

    discussion_post
  end

  private

  def notify_mentors
    solution.active_mentors.each do |mentor|
      CreateNotification.(
        mentor,
        :new_discussion_post_for_mentor,
        "#{strong display_handle(solution.user, solution.user_track)} has posted a comment on a solution you are mentoring",
        routes.mentor_solution_url(solution),
        trigger: discussion_post,

        # We want this to be the solution not the post
        # to allow for clearing without a mentor having to
        # go into every single iteration
        about: iteration
      )
      DeliverEmail.(
        mentor,
        :new_discussion_post_for_mentor,
        discussion_post
      )
    end
  end

  def user_may_comment?
    user == solution.user
  end
end
