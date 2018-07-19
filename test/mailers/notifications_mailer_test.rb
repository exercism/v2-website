require 'test_helper'

class NotificationsMailerTest < ActionMailer::TestCase
   test "new_discussion_post" do
    discussion_post = create :discussion_post
    user = discussion_post.iteration.solution.user
    mentor = discussion_post.user

    solution = discussion_post.solution
    exercise_title = solution.exercise.title
    track_title = solution.track.title

    email = UserNotificationsMailer.new_discussion_post(user, discussion_post)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["hello@exercism.io"], email.from
    assert_equal [user.email], email.to
    assert_equal "[Exercism] A mentor has commented on your solution to #{track_title}/#{exercise_title}", email.subject
  end
end
