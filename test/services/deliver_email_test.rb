require 'test_helper'

class DeliverEmailTest < ActiveSupport::TestCase
  {
    new_discussion_post: [UserNotificationsMailer, :new_discussion_post],
    new_discussion_post_for_mentor: [MentorNotificationsMailer, :new_discussion_post],

    new_discussion_post_for_mentor: [MentorNotificationsMailer, :new_discussion_post],
    new_iteration_for_mentor: [MentorNotificationsMailer, :new_iteration],
    remind_mentor: [MentorNotificationsMailer, :remind],

    new_solution_comment_for_solution_user: [SolutionCommentsMailer, :new_comment_for_solution_user],
    new_solution_comment_for_other_commenter: [SolutionCommentsMailer, :new_comment_for_other_commenter],

    mentor_heartbeat: [HeartbeatMailer, :mentor_heartbeat]
  }.each do |mail_type, (mailer, action)|
    test "mail_type: #{mail_type}" do
      user = create :user

      mailer_action = mock(:deliver_later)
      mailer.expects(action).with(user).returns(mailer_action)
      notification = DeliverEmail.(user, mail_type)
    end
  end

  test "sends if should deliver" do
    user = create :user
    discussion_post = mock
    mail_type = :new_discussion_post

    mailer_action = mock(:deliver_later)
    UserNotificationsMailer.expects(:new_discussion_post).with(user, discussion_post).returns(mailer_action)
    notification = DeliverEmail.(user, mail_type, discussion_post)
  end

  test "doesn't send if shouldn't deliver" do
    user = create :user
    user.communication_preferences.update!(email_on_new_discussion_post: false)
    discussion_post = mock
    mail_type = :new_discussion_post

    UserNotificationsMailer.expects(:new_discussion_post).never
    notification = DeliverEmail.(user, mail_type, discussion_post)
  end

  test "raises with invalid mail type" do
    assert_raises DeliverEmail::UnknownMailTypeError do
      DeliverEmail.(create(:user), :foobar)
    end
  end

  test "sets_email_log_for_preexisting_log" do
    Timecop.freeze do
      user = create :user
      log = create :user_email_log, user: user

      DeliverEmail.(user, :mentor_heartbeat, 1, 1)
      assert_equal Time.current.to_i, log.reload.mentor_heartbeat_sent_at.to_i
    end
  end

  test "sets_email_log_for_missing_log" do
    Timecop.freeze do
      user = create :user

      DeliverEmail.(user, :mentor_heartbeat, 1, 1)
      assert_equal Time.current.to_i, UserEmailLog.for_user(user).mentor_heartbeat_sent_at.to_i
    end
  end
end
