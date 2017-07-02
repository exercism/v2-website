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

  def create!
    return false unless user_may_comment?

    create_discussion_post!

    # TODO - This should be moved to backend job
    if posted_by_solution_user?
      notify_mentors
    else
      notify_solution_user
    end

    discussion_post
  end

  private
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

  def create_discussion_post!
    @discussion_post ||= DiscussionPost.create!(
      iteration: iteration,
      user: user,
      content: content,
      html: html
    )
  end

  def user_may_comment?
    return true if posted_by_solution_user?

    # TODO - Add mentor permissions
    return false
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
