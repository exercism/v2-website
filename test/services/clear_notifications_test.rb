require 'test_helper'

class ClearNotificationsTest < ActiveSupport::TestCase
  test "clears all notifications about a thing for a user" do
    user = create :user
    about = create :solution
    clear_notification1 = create :notification, user: user, about: about
    clear_notification2 = create :notification, user: user, about: about
    persist_notification = create :notification, about: about

    ClearNotifications.(user, about)
    clear_notification1.reload
    clear_notification2.reload
    persist_notification.reload

    assert clear_notification1.read?
    assert clear_notification2.read?
    refute persist_notification.read?
  end
end
