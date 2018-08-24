require 'test_helper'

class NotificationsHelperTest < ActionView::TestCase
  test "notification image is correct" do
    user = create :user

    solution = create :solution, user: user
    iteration = create :iteration, solution: solution
    discussion_post = create :discussion_post, user: user, iteration: iteration
    notification1 = create :notification, type: 'new_discussion_post', trigger: discussion_post
    notification2 = create :notification, type: 'new_discussion_post_for_mentor', trigger: discussion_post
    notification3 = create :notification, type: 'new_iteration_for_mentor', about: solution

    assert_dom_equal user.avatar_url, notification_image(notification1)
    assert_dom_equal user.avatar_url, notification_image(notification2)
    assert_dom_equal user.avatar_url, notification_image(notification3)
  end
end
