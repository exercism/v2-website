require 'test_helper'

class NotificationsHelperTest < ActionView::TestCase
  test "notification image is correct" do
    user = create :user

    solution = create :solution, user: user
    notification1 = create :notification, type: 'new_discussion_post', trigger: solution
    notification2 = create :notification, type: 'new_discussion_post_for_mentor', trigger: solution
    notification3 = create :notification, type: 'new_iteration_for_mentor', about: solution

    assert_dom_equal user.avatar_url, notification_image(notification1)
    assert_dom_equal user.avatar_url, notification_image(notification2)
    assert_dom_equal user.avatar_url, notification_image(notification3)
  end
end
