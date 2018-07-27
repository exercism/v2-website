require 'test_helper'

class IterationTest < ActiveSupport::TestCase
  test "notifications" do
    iteration = create :iteration
    random_notification = create :notification, about: iteration, trigger: create(:user)
    mentor_dp_notification = create :notification, about: iteration, trigger: create(:discussion_post), user: create(:user)
    dp_notification = create :notification, about: iteration, trigger: create(:discussion_post), user: iteration.solution.user

    assert_equal [random_notification, mentor_dp_notification, dp_notification].sort, iteration.notifications.sort
    assert_equal [dp_notification], iteration.discussion_post_notifications_for_user
  end

  test "mentor_discussion_posts" do
    iteration = create :iteration
    mentor_dp = create :discussion_post, iteration: iteration
    user_dp = create :discussion_post, iteration: iteration, user: iteration.solution.user

    assert_equal [mentor_dp, user_dp].sort, iteration.discussion_posts.sort
    assert_equal [mentor_dp], iteration.mentor_discussion_posts
  end
end
